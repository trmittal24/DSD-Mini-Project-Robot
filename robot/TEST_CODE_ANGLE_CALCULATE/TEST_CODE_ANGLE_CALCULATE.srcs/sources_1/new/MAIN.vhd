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
	RX_PIN : OUT STD_LOGIC;
	data_ready: inout STD_LOGIC;
	DataOut: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    Check_counter_mod,Check_counter_mod_diff: OUT STD_LOGIC);
	--);
	--User interface data signals
	--Read_WriteN: IN STD_LOGIC );
end MAIN;

architecture Behavioral of MAIN is
    type matrix is array(0 to 1) of std_logic_vector(7 downto 0);
    SIGNAL AddressIn: matrix;
    --SIGNAL data_ready : STD_LOGIC;
    SIGNAL MSB_VALUE,LSB_VALUE: STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL PSUEDO,l_value,u_value: STD_LOGIC_VECTOR(7 DOWNTO 0);                                                                                        
    SIGNAL Counter: INTEGER := 0;   
    SIGNAL Data_for_angle : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL angle_output : INTEGER; 
    --SIGNAL TEST_OUT : STD_LOGIC;
    SIGNAL Receive_Ack,Done_changing: STD_LOGIC := '0' ;
    SIGNAL TEST_NUMBER : INTEGER := 12345;
    SIGNAL o_TX_Active,o_TX_Done : STD_LOGIC;
                -- constants for 200kHz clock divider
    CONSTANT max200k: INTEGER := 100000000/(100000); 
    CONSTANT F500HZ  : INTEGER := 200000 ;  -- to get 100kHz for I2C standard; every 2 cycles = 1 I2C cycle  NOW  500 HZ
    --    CONSTANT max200k: INTEGER := 50000000/4;    -- for some I2C slaves (Maxim DS1375 RTC) the actual clock speed can be any speed less than the max I2C clock speed
    -- some I2C slaves (Maxim DS3232 RTC) requires a minimum SCL rate, so when this clock is too slow, the slave will reset the I2C interface
    SIGNAL clockticks200k: INTEGER RANGE 0 TO max200k;
    SIGNAL clockticks500: INTEGER RANGE 0 TO F500HZ;
    SIGNAL CLK_200k_Hz,CLK_500_Hz: STD_LOGIC;
    SIGNAL DATA_FOR_ANALYSIS: STD_LOGIC_VECTOR (15 DOWNTO 0);
    --SIGNAL FLAG : STD_LOGIC := '0';
    SIGNAL NewAddress: STD_LOGIC := '1';      
    SIGNAL REM_ONE_DIGIT: INTEGER :=0; 
    SIGNAL COUNT_TIME : INTEGER :=1;
    SIGNAL CLK : STD_LOGIC :='0';
    SIGNAL REM_ASCII : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL NUMBER: INTEGER;
    TYPE STATE_TYPE is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,S19,S20);
    SIGNAL STATE : STATE_TYPE;
    --SIGNAL ANGLE_DONE : STD_LOGIC;
    SIGNAL X,Y,Z: STD_LOGIC;


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
        
    COMPONENT gyroangle PORT(
            gyro_x              : in STD_LOGIC_VECTOR(7 DOWNTO 0);
            CLK_IN              : IN STD_LOGIC;
            --data_for_analysis   : out std_logic_vector(15 downto 0);
            gyro_anglex         : inout INTEGER );
    
    END COMPONENT;    
    
    COMPONENT UART_TX PORT(
    
        i_Clk       : in  std_logic;
        i_TX_DV     : in  std_logic;
        i_TX_Byte   : in  std_logic_vector(7 downto 0);
        o_TX_Active : out std_logic;
        o_TX_Serial : out std_logic;
        o_TX_Done   : out std_logic
    
    
    );
    END COMPONENT;
    
begin
--matrix<=(x"3B",x"3C",X"3D",X"3E",X"3F",X"40",X"43",X"44",X"45",X"46",X"47",X"48");
AddressIn<=(X"43",X"44");

Receive_data_label: ALL_IN_ONE PORT MAP(CLK_200k_Hz, ResetN, SCL,SDA, Receive_ack,PSUEDO,l_value,u_value,WokeUP,NewAddress);
GyroAnglex: gyroangle PORT MAP(Data_for_angle,CLK_500_Hz,angle_output);
UART_call: UART_TX PORT MAP(CLK_50_MHz,data_ready,REM_ASCII,o_TX_Active,RX_PIN,o_TX_Done);
PSUEDO <= X"43";
DATAOUT<= MSB_VALUE;
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
            Counter<=0;
        ELSE
            Counter<=Counter+1;                   
            Done_changing<='1';
        END IF;
      ELSE 

        Done_changing<='0';
    END IF;
    
END PROCESS;
   
   
COUNTER_CHECK: PROCESS(COUNTER)

    BEGIN
        IF COUNTER = 1 THEN 
            Check_counter_mod<='0';
            Check_counter_mod_diff<='1';
            
        ELSE
            Check_counter_mod<='1';
            Check_counter_mod_diff<='0';
        END IF;
        
    END PROCESS;
    
--    PROCESS(MSB_VALUE)
--    BEGIN
--        IF X='0' THEN
--            X <= '1';
--        ELSE
--            X <= '0';
--        END IF;
--    END PROCESS;
    
--    PROCESS(LSB_VALUE)
--    BEGIN
--        IF X='1' THEN
--            Y <= '1';
--        ELSE
--            Y <= '0';
--        END IF;
--    END PROCESS;
    
--ANGLE_CALCULATE: Process(X,Y)
--    begin
--        IF Y = '1' THEN
--        Data_for_angle<=MSB_VALUE & LSB_VALUE;
--        ELSE 
--        Data_for_angle<="0000000000000000";
--        END IF;
        
--end process;
Data_for_angle<=MSB_VALUE;
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
        
        IF clockticks500 < F500HZ THEN
                    clockticks500 <= clockticks500 + 1;
        ELSE
                    clockticks500 <= 0;
        END IF;
        
        IF clockticks500 < F500HZ/2 THEN
            CLK_500_Hz <= '0';
        ELSE
            CLK_500_Hz <= '1';
        END IF;

	END PROCESS;
--ONEhz_clk: process(clk_50_mhz) 
--    begin
--        if(clk_50_MHZ'event and clk_50_MHZ='1') then
--         count_time <=count_time+1;
--        if(count_time = 50000) then
--         clk <= not clk;
--         count_time <=1;
--        end if;
--        end if;
--    end process;
state_data_ready: PROCESS(ResetN,clk_50_mhz,state)
    BEGIN 
        IF ResetN='0' THEN 
            STATE<=S15;
            
        ELSIF clk_50_mhz'EVENT and CLK_50_mhz = '1' THEN 
    
            CASE STATE IS 
                WHEN S15 => 
                            DATA_READY <='0';
                            STATE<=S16;
    
                WHEN S16 => 
                            REM_ASCII <= "00001010";
                            STATE<=S17;
                
                WHEN S17 => 
                            DATA_READY <='1';
                            STATE<=S0;
                WHEN S0 => 
                            DATA_READY<='0';
                            NUMBER<=TEST_NUMBER;
                            STATE<=S1;
                WHEN S1 => 
                            REM_ONE_DIGIT<=(NUMBER MOD 10) + 48;
                            REM_ASCII<=std_logic_vector(to_unsigned(REM_ONE_DIGIT,REM_ASCII'length));
                            NUMBER<=NUMBER / 10;
                            STATE<=S2;
                WHEN S2 => 
                            DATA_READY<='1';
                            STATE<=S3;
                            
                WHEN S3 => 
                            DATA_READY<='0';
                            STATE<=S4;
                WHEN S4 => 
                            REM_ONE_DIGIT<=(NUMBER MOD 10) + 48;
                            REM_ASCII<=std_logic_vector(to_unsigned(REM_ONE_DIGIT,REM_ASCII'length));
                            NUMBER<=NUMBER / 10;
                            STATE<=S5;
                WHEN S5 =>
                            DATA_READY<='1';
                            STATE<=S6;
                            
                WHEN S6 => 
                            DATA_READY <='0';
                            STATE<=S7;
                            
                WHEN S7 => 
                            REM_ONE_DIGIT<=(NUMBER MOD 10) + 48;
                            REM_ASCII<=std_logic_vector(to_unsigned(REM_ONE_DIGIT,REM_ASCII'length));
                            NUMBER<=NUMBER / 10;
                            STATE<=S8;
                
                WHEN S8 => 
                            DATA_READY <='1';
                            STATE<=S9;
                            
                WHEN S9 => 
                            DATA_READY <='0';
                            STATE<=S10;
                                                      
                WHEN S10 => 
                            REM_ONE_DIGIT<=(NUMBER MOD 10) + 48;
                            REM_ASCII<=std_logic_vector(to_unsigned(REM_ONE_DIGIT,REM_ASCII'length));
                            NUMBER<=NUMBER / 10;
                            STATE<=S11;
                                          
                WHEN S11 => 
                            DATA_READY <='1';
                            STATE<=S12;                            
            
                WHEN S12 => 
                            DATA_READY <='0';
                            STATE<=S13;
                                                      
                WHEN S13 => 
                            REM_ONE_DIGIT<=(NUMBER MOD 10) + 48;
                            REM_ASCII<=std_logic_vector(to_unsigned(REM_ONE_DIGIT,REM_ASCII'length));
                            NUMBER<=NUMBER / 10;
                            STATE<=S14;
              
                WHEN S14 => 
                            DATA_READY <='1';
                            STATE<=S15;
--                WHEN S15 => 
--                            DATA_READY <='0';
--                            STATE<=S16;
                                                      
--                WHEN S16 => 
--                            REM_ONE_DIGIT<=(NUMBER MOD 10) + 48;
--                            REM_ASCII<=std_logic_vector(to_unsigned(REM_ONE_DIGIT,REM_ASCII'length));
--                            NUMBER<=NUMBER / 10;
--                            STATE<=S17;
              
--                WHEN S17 => 
--                            DATA_READY <='1';
--                            STATE<=S18;                            
--                WHEN S15 => 
--                            DATA_READY <='0';
--                            STATE<=S16;
                
--                WHEN S16 => 
--                            REM_ASCII <= "00001010";
--                            STATE<=S17;
                            
--                WHEN S17 => 
--                            DATA_READY <='1';
--                            STATE<=S0;                                                   
            
                WHEN OTHERS => NULL;
             
             END CASE;
        
        END IF ;
    
END PROCESS;

end Behavioral;	