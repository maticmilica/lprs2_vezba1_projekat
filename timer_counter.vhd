-------------------------------------------------------------------------------
--  Odsek za racunarsku tehniku i medjuracunarske komunikacije
--  Autor: LPRS2  <lprs2@rt-rk.com>                                           
--                                                                             
--  Ime modula: timer_counter                                                           
--                                                                             
--  Opis:                                                               
--                                                                             
--    Modul broji sekunde i prikazuje na LED diodama                                         
--                                                                             
-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY timer_counter IS PORT (
                               clk_i     : IN STD_LOGIC; -- ulazni takt
                               rst_i     : IN STD_LOGIC; -- reset signal 
                               one_sec_i : IN STD_LOGIC; -- signal koji predstavlja proteklu jednu sekundu vremena 
                               cnt_en_i  : IN STD_LOGIC; -- signal dozvole brojanja                              
                               cnt_rst_i : IN STD_LOGIC; -- signal resetovanja brojaca (clear signal)
                               led_o     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) -- izlaz ka led diodama
                             );
END timer_counter;

ARCHITECTURE rtl OF timer_counter IS


SIGNAL counter_value_r : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal sClk : std_logic;
signal sRst : std_logic;
signal mux3out : std_logic_vector(7 downto 0);
signal muxCntOut : std_logic_vector(7 downto 0);


component reg
	generic(
		WIDTH    : positive := 1;
		RST_INIT : integer := 0
	);
	port(
		i_clk  : in  std_logic;
		in_rst : in  std_logic;
		i_d    : in  std_logic_vector(WIDTH-1 downto 0);
		o_q    : out std_logic_vector(WIDTH-1 downto 0)
	);
end component;



BEGIN

-- DODATI :
-- brojac koji na osnovu izbrojanih sekundi pravi izlaz na LE diode
	tim_reg : reg generic map(
		WIDTH => 8,
		RST_INIT => 0
	)
	port map(
		i_clk => sClk,
		in_rst => sRst,
		i_d => mux3out,
		o_q => counter_value_r
	);
	
	sRst <= not rst_i;
	sClk <= clk_i;
	
	
	mux3Out <= muxCntOut when cnt_rst_i = '0'
					else (others => '0');
	
	muxCntOut <= counter_value_r + 1 when one_sec_i = '1'
					else counter_value_r;
	
	
	led_o <= counter_value_r;
	
END rtl;