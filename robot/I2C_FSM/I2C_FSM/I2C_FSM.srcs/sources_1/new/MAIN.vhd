----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.09.2017 18:36:48
-- Design Name: 
-- Module Name: MAIN - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MAIN is
  Port (CLK_50_MHz, ResetN: IN STD_LOGIC;
	--RTC/I2C control signals
	SCL: OUT STD_LOGIC;
	SDA: INOUT STD_LOGIC;
	WokeUp: INOUT STD_LOGIC;
	Check_counter_mod,Check_counter_mod_diff: OUT STD_LOGIC);
	--DataOut: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
	--User interface data signals
	--Read_WriteN: IN STD_LOGIC );
end MAIN;

architecture Behavioral of MAIN is
    type matrix is array(0 to 1) of std_logic_vector(7 downto 0);
    
    SIGNAL AddressIn: matrix;
    SIGNAL MSB_VALUE,LSB_VALUE: STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL PSUEDO,l_value,u_value: STD_LOGIC_VECTOR(7 DOWNTO 0);                                                                                        
    SIGNAL Counter: INTEGER := 0;   
    SIGNAL DataOut: STD_LOGIC_VECTOR(15 DOWNTO 0);
    --SIGNAL TEST_OUT : STD_LOGIC;
    SIGNAL Receive_Ack,Done_changing: STD_LOGIC := '0' ;
            -- constants for 200kHz clock divider
    CONSTANT max200k: INTEGER := 100000000/(1000*2);    -- to get 100kHz for I2C standard; every 2 cycles = 1 I2C cycle
    --    CONSTANT max200k: INTEGER := 50000000/4;    -- for some I2C slaves (Maxim DS1375 RTC) the actual clock speed can be any speed less than the max I2C clock speed
    -- some I2C slaves (Maxim DS3232 RTC) requires a minimum SCL rate, so when this clock is too slow, the slave will reset the I2C interface
    SIGNAL clockticks200k: INTEGER RANGE 0 TO max200k;
    SIGNAL CLK_200k_Hz: STD_LOGIC;
    SIGNAL FLAG : STD_LOGIC := '0';
    SIGNAL NewAddress: STD_LOGIC := '1';       
    COMPONENT ALL_IN_ONE PORT(CLK_200k_Hz, ResetN: IN STD_LOGIC;
            --RTC/I2C control signals
            SCL: OUT STD_LOGIC;
            SDA: INOUT STD_LOGIC;
            Receive_ack: INOUT STD_LOGIC;
            AddressIn: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            DataOut_l: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            DataOut_u: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	
            WokeUp: INOUT STD_LOGIC;
            Newaddress: IN Std_logic); 
            
            END COMPONENT;
    
begin
--matrix<=(x"3B",x"3C",X"3D",X"3E",X"3F",X"40",X"43",X"44",X"45",X"46",X"47",X"48");
AddressIn<=(X"43",X"44");

Receive_data_label: ALL_IN_ONE PORT MAP(CLK_200k_Hz, ResetN, SCL,SDA, Receive_ack,PSUEDO,l_value,u_value,WokeUP,NewAddress);
PSUEDO <= AddressIn(Counter);
DataOut <= MSB_VALUE & LSB_VALUE;
LSB_value <= l_value;
MSB_VALUE <= u_value;
            
RECEIVE: PROCESS(WokeUP,Receive_ack)

       BEGIN 
                   
            IF ( Receive_ack = '1' and WokeUP='1') THEN
                NewAddress <= '0';
                
            ELSIF(Done_changing='1') THEN 
                NewAddress<='1';
                                                  
                   
            END IF;
      END PROCESS; 

CHANGE_ADDRESS: PROCESS(NewAddress)
 BEGIN 
      IF (NewAddress='0') THEN 
        
        IF Counter = 1 THEN 
            Check_counter_mod<='0';
            Check_counter_mod_diff<='1';
            Counter<=0;
        ELSE
            Counter<=Counter+1;
            Check_counter_mod<='1';
            Check_counter_mod_diff<='0';
         
            Done_changing<='1';
        END IF;
      ELSE 

        Done_changing<='0';
    END IF;
    
END PROCESS;
   
clockdivider200k: PROCESS
	BEGIN
		WAIT UNTIL CLK_50_MHz'EVENT and CLK_50_MHz = '1';
		IF clockticks200k < max200k THEN
			clockticks200k <= clockticks200k + 1;
		ELSE
			clockticks200k <= 0;
		END IF;
		IF clockticks200k < max200k/2 THEN
			CLK_200k_Hz <= '0';
		ELSE
			CLK_200k_Hz <= '1';
		END IF;
	END PROCESS;

end Behavioral;
