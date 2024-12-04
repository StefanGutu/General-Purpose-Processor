library verilog;
use verilog.vl_types.all;
entity DEC16bit is
    port(
        inp             : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        \out\           : out    vl_logic_vector(15 downto 0)
    );
end DEC16bit;
