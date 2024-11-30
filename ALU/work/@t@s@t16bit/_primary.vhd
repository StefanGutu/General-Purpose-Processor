library verilog;
use verilog.vl_types.all;
entity TST16bit is
    port(
        inp1            : in     vl_logic_vector(15 downto 0);
        inp2            : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        zero_flag       : out    vl_logic;
        negative_flag   : out    vl_logic;
        carry_flag      : out    vl_logic;
        overflow_flag   : out    vl_logic
    );
end TST16bit;
