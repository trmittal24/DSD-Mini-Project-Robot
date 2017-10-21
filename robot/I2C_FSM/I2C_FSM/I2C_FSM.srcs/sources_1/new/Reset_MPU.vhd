LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Reset_MPU IS
PORT (
	CLK_200k_Hz, ResetN: IN STD_LOGIC;
	TEST_OUT: OUT STD_LOGIC;
	--RTC/I2C control signals
	SCL: OUT STD_LOGIC;
	SDA: INOUT STD_LOGIC;
	FLAG : IN STD_LOGIC);
	--User interface data signals
	--Read_WriteN: IN STD_LOGIC;
	--DataIn, AddressIn: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	--Ack: OUT STD_LOGIC;
	--DataOut: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	--StateOut: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	--RegisterAddressOut: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END Reset_MPU ;

ARCHITECTURE FSMD OF Reset_MPU IS
	SIGNAL state: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL RegisterAddress: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Data: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL SDA01: STD_LOGIC;	-- internal SDA having values of 0 and 1
	
	SIGNAL bitcount: INTEGER RANGE 0 TO 7;
	CONSTANT SlaveAddress_Read: STD_LOGIC_VECTOR(7 DOWNTO 0) := "1101000"&'1';	-- I2C address of the slave + read
	CONSTANT SlaveAddress_Write: STD_LOGIC_VECTOR(7 DOWNTO 0) := "1101000"&'0';	-- I2C address of the slave + write'
	CONSTANT NumberOfRegisters: STD_LOGIC_VECTOR(7 DOWNTO 0) := x"1F";	-- total number of registers in the slave
	
	-- constants for 200kHz clock divider
	CONSTANT max200k: INTEGER := 100000000/(100000*2);	-- to get 100kHz for I2C standard; every 2 cycles = 1 I2C cycle
--	CONSTANT max200k: INTEGER := 50000000/4;	-- for some I2C slaves (Maxim DS1375 RTC) the actual clock speed can be any speed less than the max I2C clock speed
	-- some I2C slaves (Maxim DS3232 RTC) requires a minimum SCL rate, so when this clock is too slow, the slave will reset the I2C interface
	SIGNAL clockticks200k: INTEGER RANGE 0 TO max200k;
	--SIGNAL CLK_200k_Hz: STD_LOGIC;
	CONSTANT  DataIn :STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	CONSTANT AddressIn: STD_LOGIC_VECTOR(7 DOWNTO 0) := "01101011";
	CONSTANT Read_WriteN: STD_LOGIC := '0';
	SIGNAL Ack: STD_LOGIC;
    SIGNAL DataOut: STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL StateOut: STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL RegisterAddressOut:STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL TEST : STD_LOGIC := '0';
	
BEGIN
    TEST_OUT <= TEST;
	StateOut <= state;
	
	-- SDA line is open drain that is pulled up with a resistor
	-- therefore, to set SDA to a 1 we need to output a Z value
	-- SDA is changed only when SCL is low except for sending the start and stop bits
	-- i.e. SDA is valid at the rising edge of the SCL (clock)
	SDA <= 'Z' WHEN SDA01 = '1' ELSE '0';	-- convert SDA 0/1 to 0/Z

	output: PROCESS(CLK_200k_Hz, ResetN)
	BEGIN
	 case FLAG is
	 WHEN '1' =>
		IF(ResetN = '0') THEN
			-- when idle, both SDA and SCL = 1  
			SCL <= '1';
			SDA01 <= '1';
			Ack <= '0';
			DataOut <= "00000000";
			RegisterAddress <= x"FF";
			state <= x"00";
		ELSIF(CLK_200k_Hz'EVENT and CLK_200k_Hz = '1') THEN
			CASE state IS
			WHEN x"00" =>	-- Idle
				-- when idle, both SDA and SCL = 1
				SCL <=  '1';		-- SCL = 1
				SDA01 <= '1';	-- SDA = 1
				--RegisterAddressOut <= RegisterAddress;
				DataOut <= "00000000";
				state <= x"01";
				
----------------------------------------------------------------				
-- send start condition and slave address
			WHEN x"01" =>	-- Start
				SCL <= '1';		-- SCL stays at 1 while
				SDA01 <= '0';	-- SDA changes from 1 to 0
				bitcount <= 7;	-- starting bit count
				state <= x"02";
			-- send 7-bit slave address followed by R/W' bit, MSB first
			WHEN x"02" =>					
				SCL <= '0';
				SDA01 <= SlaveAddress_Write(bitcount);
				state <= x"03";
			WHEN x"03" =>
				SCL <= '1';
				IF (bitcount - 1) >= 0 THEN
					bitcount <= bitcount - 1;
					state <= x"02";
				ELSE
					bitcount <= 7;
					state <= x"12";
				END IF;
			-- get acknowledgment' from slave
			WHEN x"12" =>
				SCL <= '0';
				SDA01 <= '1';
				state <= x"13";
			WHEN x"13" =>
				SCL <= '1';
				Ack <= SDA;	-- 0 = acknowledge'; error if it is a 1
				IF SDA = '1' THEN
					--RegisterAddressOut <= x"13";
					state <= x"EE";	-- acknowledge error
				ELSE
					state <= x"20";	-- send register address
				END IF;

----------------------------------------------------------------
			-- send 8-bit register address to slave
			WHEN x"20" =>
				SCL <= '0';
				SDA01 <= AddressIn(bitcount);	-- register address MSB first
				state <= x"21";	-- continue
			WHEN x"21" =>
				SCL <= '1';
				IF (bitcount - 1) >= 0 THEN
					bitcount <= bitcount - 1;
					state <= x"20";
				ELSE
					bitcount <= 7;
					state <= x"30";
				END IF;
			-- get acknowledgment'
			WHEN x"30" =>
				SCL <= '0';
				SDA01 <= '1';
				state <= x"31";
			WHEN x"31" =>
				SCL <= '1';
				Ack <= SDA;	-- 0 = acknowledge'; error if it is a 1
				RegisterAddress <= AddressIn;
				IF SDA = '1' THEN
					--RegisterAddressOut <= x"31";
					state <= x"EE"; -- acknowledge error
				ELSIF Read_WriteN = '0' THEN
					state <= x"40";	-- go do a write
				ELSE
					state <= x"70";	-- send repeated start and then go do a read
				END IF;


----------------------------------------------------------------				
-- going to write data to slave
			-- send 8-bit data to slave
			WHEN x"40" =>
				SCL <= '0';
				SDA01 <= DataIn(bitcount); 	-- Data MSB first
				state <= x"41";
			WHEN x"41" =>
				SCL <= '1';
				IF (bitcount - 1) >= 0 THEN
					bitcount <= bitcount - 1;
					state <= x"40";
				ELSE
					bitcount <= 7;
					state <= x"50";
				END IF;
			-- get acknowledgment'
			WHEN x"50" =>
				SCL <= '0';
				SDA01 <= '1';
				--RegisterAddressOut <= AddressIn;
				DataOut <= DataIn;
				state <= x"51";
			WHEN x"51" =>
				SCL <= '1';
				Ack <= SDA;	-- 0 = acknowledge'; error if it is a 1
				IF SDA = '1' THEN
					--RegisterAddressOut <= x"51";
					state <= x"EE";
				ELSE	-- send stop
					state <= x"52";
				END IF;
			-- send stop
			-- SDA goes from 0 to 1 while SCL is 1
			WHEN x"52" =>
				SCL <= '0';
				SDA01 <= '0';	-- SDA starts at 0 to prepare for the 0 to 1 transition
				state <= x"53";
			WHEN x"53" =>
				SCL <= '1';		-- SCL goes to 1
				SDA01 <= '0';	-- SDA starts from 0
				state <= x"54";
			WHEN x"54" =>	-- idle state
				SCL <= '1';		-- SCL stays at 1 while
				SDA01 <= '1';	-- SDA goes to 1
				state <= x"54";
				TEST<= '1';
				
           WHEN OTHERS => null;
                SCL <= '1';
                SDA01 <= '1';
        END CASE;
    END IF;
  WHEN OTHERS => null;  
  END CASE;
END PROCESS;			

END FSMD;