library verilog;
use verilog.vl_types.all;
entity XOR16bit is
    port(
        inp1            : in     vl_logic_vector(15 downto 0);
        inp2            : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        \out\           : out    vl_logic_vector(15 downto 0)
    );
end XOR16bit;
