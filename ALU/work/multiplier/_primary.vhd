library verilog;
use verilog.vl_types.all;
entity multiplier is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        \out\           : out    vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end multiplier;
