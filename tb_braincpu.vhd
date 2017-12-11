-- Testbench automatically generated online
-- at http://vhdl.lapinoo.net
-- Generation date : 11.12.2017 01:19:37 GMT

library ieee;
use ieee.std_logic_1164.all;

entity tb_braincpu is
end tb_braincpu;

architecture tb of tb_braincpu is

    component braincpu
        port (clk              : in std_logic;
              u_in_4bit        : in std_logic_vector (3 downto 0);
              u_in_btn_a_inv   : in std_logic;
              u_in_btn_rst_inv : in std_logic;
              u_out_8bit       : out std_logic_vector (7 downto 0));
    end component;

    signal clk              : std_logic;
    signal u_in_4bit        : std_logic_vector (3 downto 0);
    signal u_in_btn_a_inv   : std_logic;
    signal u_in_btn_rst_inv : std_logic;
    signal u_out_8bit       : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : braincpu
    port map (clk              => clk,
              u_in_4bit        => u_in_4bit,
              u_in_btn_a_inv   => u_in_btn_a_inv,
              u_in_btn_rst_inv => u_in_btn_rst_inv,
              u_out_8bit       => u_out_8bit);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        u_in_4bit <= (others => '0');
        u_in_btn_a_inv <= '0';

        -- Reset generation
        -- EDIT: Check that u_in_btn_rst_inv is really your reset signal
        u_in_btn_rst_inv <= '0';
        wait for 100 ns;
        u_in_btn_rst_inv <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 100 * TbPeriod;

		  
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_braincpu of tb_braincpu is
    for tb
    end for;
end cfg_tb_braincpu;