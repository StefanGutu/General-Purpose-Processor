library verilog;
use verilog.vl_types.all;
entity MOV16bit is
    port(
        src             : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        mov_enable      : in     vl_logic;
        dest            : out    vl_logic_vector(15 downto 0)
    );
end MOV16bit;
