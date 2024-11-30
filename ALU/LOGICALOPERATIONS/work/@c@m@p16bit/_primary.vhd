library verilog;
use verilog.vl_types.all;
entity CMP16bit is
    port(
        inp1            : in     vl_logic_vector(15 downto 0);
        inp2            : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        equal           : out    vl_logic;
        greater         : out    vl_logic;
        less            : out    vl_logic
    );
end CMP16bit;
