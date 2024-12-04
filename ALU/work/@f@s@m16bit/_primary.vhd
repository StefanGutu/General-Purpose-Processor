library verilog;
use verilog.vl_types.all;
entity FSM16bit is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        mov_enable      : in     vl_logic;
        op_code         : in     vl_logic_vector(4 downto 0);
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        bin             : in     vl_logic;
        cin             : in     vl_logic;
        result          : out    vl_logic_vector(15 downto 0);
        remainder       : out    vl_logic_vector(15 downto 0);
        bout            : out    vl_logic;
        busy            : out    vl_logic
    );
end FSM16bit;
