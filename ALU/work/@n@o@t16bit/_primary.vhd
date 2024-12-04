library verilog;
use verilog.vl_types.all;
entity NOT16bit is
    port(
        inp             : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        \out\           : out    vl_logic_vector(15 downto 0)
    );
end NOT16bit;
