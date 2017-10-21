----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.09.2017 14:39:14
-- Design Name: 
-- Module Name: test - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gyroangle is
    Port (  gyro_x              : in STD_LOGIC_VECTOR(7 DOWNTO 0);
            CLK_IN              : IN STD_LOGIC;
            --data_for_analysis   :out std_logic_vector(15 downto 0);
            --quotient            : out STD_LOGIC_VECTOR(15 DOWNTO 0);
            --remainder_precision : out STD_LOGIC_VECTOR(15 DOWNTO 0);
            gyro_anglex         : inout INTEGER 
          );
end gyroangle;

architecture Behavioral of gyroangle is
--TYPE STATE_TYPE IS (S0,S1,S2);
--SIGNAL STATE            :   STATE_TYPE := S0;
SIGNAL Senstivity       :   INTEGER := 131;  --senstiviy of gyroscope   
SIGNAL rem_int,gyro_int :   INTEGER RANGE 0 TO 65535 :=0;
SIGNAL gyro_dt          :   INTEGER:=500;   --freequency is set to 500Hz
SIGNAL GYRO_ANGLE       :   INTEGER :=0;  

begin
    
       
ANGLE_CAL:process(CLK_IN)
        BEGIN  
            IF CLK_IN'EVENT AND CLK_IN='1' THEN 
                
                gyro_int<=to_integer(signed(gyro_x));
                rem_int<=(gyro_int*1000)/(Senstivity*gyro_dt);
                GYRO_ANGLE<=GYRO_ANGLE + rem_int;
                GYRO_ANGLEx<=GYRO_ANGLE; 
                
            END IF;
        
        END PROCESS;    
         
             
             
                        --every value is scaled to 10^5 so during all the arihematic operation we have to include a factor of 10^5
        
         
end Behavioral;