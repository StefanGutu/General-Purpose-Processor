library verilog;
use verilog.vl_types.all;
entity CLA16bit is
    port(
        a               : in     vl_logic_vector(15 downto 0);
        b               : in     vl_logic_vector(15 downto 0);
        cin             : in     vl_logic;
        sum             : out    vl_logic_vector(15 downto 0);
        cout            : out    vl_logic;
        clk             : in     vl_logic;
        rst             : in     vl_logic
    );
end CLA16bit;
