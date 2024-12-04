library verilog;
use verilog.vl_types.all;
entity FullSubtractor16bit is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        bin             : in     vl_logic;
        diff            : out    vl_logic_vector(15 downto 0);
        bout            : out    vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end FullSubtractor16bit;
