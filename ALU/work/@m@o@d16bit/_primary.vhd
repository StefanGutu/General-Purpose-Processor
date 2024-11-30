library verilog;
use verilog.vl_types.all;
entity MOD16bit is
    port(
        num             : in     vl_logic_vector(15 downto 0);
        imp             : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        result          : out    vl_logic_vector(15 downto 0)
    );
end MOD16bit;
