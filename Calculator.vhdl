-- Charles Gouert
-- Matthew Leung

library ieee;
use ieee.std_logic_1164.all;
entity calculator is 
port(	registerOne : in std_logic_vector(7 downto 0);
	registerTwo : in std_logic_vector(7 downto 0);
	registerThree : in std_logic_vector(7 downto 0);
	registerFour : in std_logic_vector(7 downto 0);
	outRegisterOne : out std_logic_vector(7 downto 0);
	outRegisterTwo : out std_logic_vector(7 downto 0);
	outRegisterThree : out std_logic_vector(7 downto 0);
	outRegisterFour : out std_logic_vector(7 downto 0);
	inputZero : in std_logic;
	inputOne : in std_logic;
	inputTwo : in std_logic;
	inputThree : in std_logic;
	inputFour : in std_logic;
	inputFive : in std_logic;
	inputSix : in std_logic;
	inputSeven : in std_logic;
	skip : in integer range 0 to 3;
	outSkip : out integer range 0 to 3;
	clock : in std_logic
);
end entity calculator;

architecture behavioral of calculator is 

begin
process(clock)
variable operandOne : std_logic_vector(7 downto 0);
variable operandTwo : std_logic_vector(7 downto 0);
variable result : std_logic_vector(7 downto 0);
variable carry : std_logic;
variable carryTwo : std_logic;
variable carryThree : std_logic;
variable tempSkip : integer range 0 to 3;
begin

-- instruction select
if (inputZero = '0' and inputOne = '0' and skip = 0) then -- add

	-- determine first operand 
	if (inputSeven = '0' and inputSix = '0') then
		operandOne := registerOne;
	elsif (inputSeven = '0' and inputSix = '1') then
		operandOne := registerTwo;
	elsif (inputSeven = '1' and inputSix = '0') then
		operandOne := registerThree;
	else
		operandOne := registerFour;
	end if;

	-- determine second operand
	if (inputFive = '0' and inputFour = '0') then
		operandTwo := registerOne;
	elsif (inputFive = '0' and inputFour = '1') then
		operandTwo := registerTwo;
	elsif (inputFive = '1' and inputFour = '0') then
		operandTwo := registerThree;
	else
		operandTwo := registerFour;
	end if;

	-- addition
	result(0) := operandOne(0) xor operandTwo(0);
	carry := operandOne(0) and operandTwo(0);
	result(1) := (operandOne(1) and operandTwo(1) and carry) or ((operandOne(1) xor operandTwo(1)) and (not carry)) or ((not operandOne(1)) and (not operandTwo(1)) and carry);
	carryTwo := (operandOne(1) and operandTwo(1)) or (operandOne(1) and carry) or (operandTwo(1) and carry);
	result(2) := (operandOne(2) and operandTwo(2) and carryTwo) or ((operandOne(2) xor operandTwo(2)) and (not carryTwo)) or ((not operandOne(2)) and (not operandTwo(2)) and carryTwo);
	carryThree := (operandOne(2) and operandTwo(2)) or (operandOne(2) and carryTwo) or (operandTwo(2) and carryTwo);
	result(3) := (operandOne(3) and operandTwo(3) and carryThree) or ((operandOne(3) xor operandTwo(3)) and (not carryThree)) or ((not operandOne(3)) and (not operandTwo(3)) and carryThree);
	result(4) := result(3);
	result(5) := result(3);
	result(6) := result(3);
	result(7) := result(3);

	-- determine destination register
	if (inputThree = '0' and inputTwo = '0') then
		outRegisterOne <= result;
	elsif (inputThree = '0' and inputTwo = '1') then
		outRegisterTwo <= result;
	elsif (inputThree = '1' and inputTwo = '0') then
		outRegisterThree <= result;
	else
		outRegisterFour <= result;
	end if;

elsif (inputZero = '1' and inputOne = '0' and skip = 0) then -- subtract

	-- determine first operand 
	if (inputSeven = '0' and inputSix = '0') then
		operandOne := registerOne;
	elsif (inputSeven = '0' and inputSix = '1') then
		operandOne := registerTwo;
	elsif (inputSeven = '1' and inputSix = '0') then
		operandOne := registerThree;
	else
		operandOne := registerFour;
	end if;

	-- determine second operand
	if (inputFive = '0' and inputFour = '0') then
		operandTwo := registerOne;
	elsif (inputFive = '0' and inputFour = '1') then
		operandTwo := registerTwo;
	elsif (inputFive = '1' and inputFour = '0') then
		operandTwo := registerThree;
	else
		operandTwo := registerFour;
	end if;

	-- change sign of operandTwo before adding
	if (operandTwo(0) = '1') then
		operandTwo(1) := not operandTwo(1);
		operandTwo(2) := not operandTwo(2);
		operandTwo(3) := not operandTwo(3);
		operandTwo(4) := operandTwo(3);
		operandTwo(5) := operandTwo(3);
		operandTwo(6) := operandTwo(3);
		operandTwo(7) := operandTwo(3);
	else
		operandTwo(1) := not operandTwo(1);
		operandTwo(2) := not operandTwo(2);
		operandTwo(3) := not operandTwo(3);
		operandTwo(4) := operandTwo(3);
		operandTwo(5) := operandTwo(3);
		operandTwo(6) := operandTwo(3);
		operandTwo(7) := operandTwo(3);
		if (operandTwo(1) = '0') then
			operandTwo(1) := '1';
		else
			operandTwo(1) := '0';
			if (operandTwo(2) = '0') then
				operandTwo(2) := '1';
			else
				operandTwo(2) := '0';
				if (operandTwo(3) = '0') then
					operandTwo(3) := '1';
				else
					operandTwo(3) := '0';
				end if;
			end if;
		end if;
	end if;

	-- subtraction
	result(0) := operandOne(0) xor operandTwo(0);
	carry := operandOne(0) and operandTwo(0);
	result(1) := (operandOne(1) and operandTwo(1) and carry) or ((operandOne(1) xor operandTwo(1)) and (not carry)) or ((not operandOne(1)) and (not operandTwo(1)) and carry);
	carryTwo := (operandOne(1) and operandTwo(1)) or (operandOne(1) and carry) or (operandTwo(1) and carry);
	result(2) := (operandOne(2) and operandTwo(2) and carryTwo) or ((operandOne(2) xor operandTwo(2)) and (not carryTwo)) or ((not operandOne(2)) and (not operandTwo(2)) and carryTwo);
	carryThree := (operandOne(2) and operandTwo(2)) or (operandOne(2) and carryTwo) or (operandTwo(2) and carryTwo);
	result(3) := (operandOne(3) and operandTwo(3) and carryThree) or ((operandOne(3) xor operandTwo(3)) and (not carryThree)) or ((not operandOne(3)) and (not operandTwo(3)) and carryThree);
	result(4) := result(3);
	result(5) := result(3);
	result(6) := result(3);
	result(7) := result(3);

	-- determine destination register
	if (inputThree = '0' and inputTwo = '0') then
		outRegisterOne <= result;
	elsif (inputThree = '0' and inputTwo = '1') then
		outRegisterTwo <= result;
	elsif (inputThree = '1' and inputTwo = '0') then
		outRegisterThree <= result;
	else
		outRegisterFour <= result;
	end if;

elsif (inputZero = '1' and inputOne = '1' and inputTwo = '0' and skip = 0) then -- compare

	-- determine first register 
	if (inputSix = '0' and inputFive = '0') then
		operandOne := registerOne;
	elsif (inputSix = '0' and inputFive = '1') then
		operandOne := registerTwo;
	elsif (inputSix = '1' and inputFive = '0') then
		operandOne := registerThree;
	else
		operandOne := registerFour;
	end if;

	-- determine second register
	if (inputFour = '0' and inputThree = '0') then
		operandTwo := registerOne;
	elsif (inputFour = '0' and inputThree = '1') then
		operandTwo := registerTwo;
	elsif (inputFour = '1' and inputThree = '0') then
		operandTwo := registerThree;
	else
		operandTwo := registerFour;
	end if;

	if (operandOne = operandTwo) then
		if (inputSeven = '1') then
			tempSkip := 3;
		else
			tempSkip := 2;
		end if;
	end if;

elsif (inputZero = '1' and inputOne = '1' and inputTwo = '1' and skip = 0) then -- print

	-- determine register 
	if (inputFour = '0' and inputThree = '0') then
		operandOne := registerOne;
	elsif (inputFour = '0' and inputThree = '1') then
		operandOne := registerTwo;
	elsif (inputFour = '1' and inputThree = '0') then
		operandOne := registerThree;
	else
		operandOne := registerFour;
	end if;

	if (operandOne(0) = '0' and operandOne(1) = '0' and operandOne(2) = '0' and operandOne(3) = '0') then
		report(integer'image(0));
	elsif (operandOne(0) = '1' and operandOne(1) = '0' and operandOne(2) = '0' and operandOne(3) = '0') then
		report(integer'image(1));
	elsif (operandOne(0) = '0' and operandOne(1) = '1' and operandOne(2) = '0' and operandOne(3) = '0') then
		report(integer'image(2));
	elsif (operandOne(0) = '1' and operandOne(1) = '1' and operandOne(2) = '0' and operandOne(3) = '0') then
		report(integer'image(3));
	elsif (operandOne(0) = '0' and operandOne(1) = '0' and operandOne(2) = '1' and operandOne(3) = '0') then
		report(integer'image(4));
	elsif (operandOne(0) = '1' and operandOne(1) = '0' and operandOne(2) = '1' and operandOne(3) = '0') then
		report(integer'image(5));
	elsif (operandOne(0) = '0' and operandOne(1) = '1' and operandOne(2) = '1' and operandOne(3) = '0') then
		report(integer'image(6));
	elsif (operandOne(0) = '1' and operandOne(1) = '1' and operandOne(2) = '1' and operandOne(3) = '0') then
		report(integer'image(7));
	elsif (operandOne(0) = '0' and operandOne(1) = '0' and operandOne(2) = '0' and operandOne(3) = '1') then
		report(integer'image(-8));
	elsif (operandOne(1) = '1' and operandOne(1) = '0' and operandOne(2) = '0' and operandOne(3) = '1') then
		report(integer'image(-7));
	elsif (operandOne(0) = '0' and operandOne(1) = '1' and operandOne(2) = '0' and operandOne(3) = '1') then
		report(integer'image(-6));
	elsif (operandOne(0) = '1' and operandOne(1) = '1' and operandOne(2) = '0' and operandOne(3) = '1') then
		report(integer'image(-5));
	elsif (operandOne(0) = '0' and operandOne(1) = '0' and operandOne(2) = '1' and operandOne(3) = '1') then
		report(integer'image(-4));
	elsif (operandOne(0) = '0' and operandOne(1) = '1' and operandOne(2) = '1' and operandOne(3) = '1') then
		report(integer'image(-2));
	elsif (operandOne(0) = '1' and operandOne(1) = '1' and operandOne(2) = '1' and operandOne(3) = '1') then
		report(integer'image(-1));
	end if;

elsif (inputZero = '0' and inputOne = '1' and skip = 0) then --load

	-- sign extended immediate value
	result(0) := inputFour;
	result(1) := inputFive;
	result(2) := inputSix;
	result(3) := inputSeven;
	result(4) := inputSeven;
	result(5) := inputSeven;
	result(6) := inputSeven;
	result(7) := inputSeven;

	-- determine destination register
	if (inputThree = '0' and inputTwo = '0') then
		outRegisterOne <= result;
	elsif (inputThree = '0' and inputTwo = '1') then
		outRegisterTwo <= result;
	elsif (inputThree = '1' and inputTwo = '0') then
		outRegisterThree <= result;
	else
		outRegisterFour <= result;
	end if;
end if;


if (tempSkip = 3) then
	outSkip <= 2;
elsif (tempSkip = 2) then
	outSkip <= 1;
else
	outSkip <= 0;
end if;

end process;
end architecture;