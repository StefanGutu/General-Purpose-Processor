library verilog;
use verilog.vl_types.all;
entity divider is
    port(
        dividend        : in     vl_logic_vector(15 downto 0);
        divisor         : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        quotient        : out    vl_logic_vector(15 downto 0);
        remainder       : out    vl_logic_vector(15 downto 0)
    );
end divider;
