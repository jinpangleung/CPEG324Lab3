library ieee;
use ieee.std_logic_1164.all;

entity calculatorTest is
end calculatorTest;

architecture behavioral of calculatorTest is 
component calculator
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
end component;

signal RegisterOne, RegisterTwo, RegisterThree, RegisterFour, OutRegisterOne, OutRegisterTwo, OutRegisterThree, OutRegisterFour, ExpectedAnswer : std_logic_vector(7 downto 0);
signal InputZero, InputOne, InputTwo, InputThree, InputFour, InputFive, InputSix, InputSeven, InputEight, Clock : std_logic;
signal Skip, OutSkip : integer range 0 to 3;

begin 
calculator1: calculator port map (registerOne => RegisterOne, registerTwo => RegisterTwo, registerThree => RegisterThree, registerFour => RegisterFour, outRegisterOne => OutRegisterOne, outRegisterTwo => OutRegisterTwo, outRegisterThree => OutRegisterThree, outRegisterFour => OutRegisterFour, inputZero => InputZero, inputOne => InputOne, inputTwo => InputTwo, inputThree => InputThree, inputFour => InputFour, inputFive => InputFive, inputSix => InputSix, inputSeven => InputSeven, skip => Skip, outSkip => OutSkip, clock => Clock);
process
begin

RegisterOne <= "11111001";
RegisterTwo <= "00000001";
RegisterThree <= "00000000";
RegisterFour <= "00000011";
InputZero <= '0';
InputOne <= '0';
InputTwo <= '0';
InputThree <= '0';
InputFour <= '1';
InputFive <= '1';
InputSix <= '0';
InputSeven <= '0';
Skip <= 0;
Clock <= '1';
ExpectedAnswer <= "11111100";
wait for 10 ns;

for i in 7 downto 0 loop
	assert(OutRegisterOne(i) = ExpectedAnswer(i)) report "Addition 1 test failed!!!";
end loop;

RegisterOne <= "00000000";
RegisterTwo <= "00000000";
RegisterThree <= "00000010";
RegisterFour <= "00000001";
InputZero <= '1';
InputOne <= '0';
InputTwo <= '1';
InputThree <= '0';
InputFour <= '1';
InputFive <= '1';
InputSix <= '0';
InputSeven <= '1';
Skip <= OutSkip;
Clock <= '0';
ExpectedAnswer <= "00000001";
wait for 10 ns;

for i in 7 downto 0 loop
	assert(OutRegisterTwo(i) = ExpectedAnswer(i)) report "Subtraction 1 test failed!!!";
end loop;

RegisterOne <= "00000000";
RegisterTwo <= "00000000";
RegisterThree <= "00000000";
RegisterFour <= "00000000";
InputZero <= '1';
InputOne <= '1';
InputTwo <= '0';
InputThree <= '1';
InputFour <= '0';
InputFive <= '0';
InputSix <= '0';
InputSeven <= '1';
Skip <= OutSkip;
Clock <= '1';
wait for 10 ns;

assert(OutSkip = 2) report "Compare 1 test failed!!!";

-- print test (should print 4)
RegisterOne <= "00000001";
RegisterTwo <= "00000010";
RegisterThree <= "00000011";
RegisterFour <= "00000100";
InputZero <= '1';
InputOne <= '1';
InputTwo <= '1';
InputThree <= '1';
InputFour <= '1';
InputFive <= '0';
InputSix <= '0';
InputSeven <= '0';
Skip <= 0;
Clock <= '0';
wait for 10 ns;

-- print test 2 (should print -8)
RegisterOne <= "00000001";
RegisterTwo <= "00000010";
RegisterThree <= "11111000";
RegisterFour <= "00000100";
InputZero <= '1';
InputOne <= '1';
InputTwo <= '1';
InputThree <= '0';
InputFour <= '1';
InputFive <= '0';
InputSix <= '0';
InputSeven <= '0';
Skip <= 0;
Clock <= '1';
wait for 10 ns;

RegisterOne <= "00000000";
RegisterTwo <= "00000000";
RegisterThree <= "00000000";
RegisterFour <= "00000000";
InputZero <= '0';
InputOne <= '1';
InputTwo <= '0';
InputThree <= '0';
InputFour <= '1';
InputFive <= '0';
InputSix <= '0';
InputSeven <= '1';
Skip <= 0;
Clock <= '0';
ExpectedAnswer <= "11111001";
wait for 10 ns;

for i in 7 downto 0 loop
	assert(OutRegisterOne(i) = ExpectedAnswer(i)) report "Load 1 Test Failed!!!";
end loop;

wait;
end process;
end behavioral;


