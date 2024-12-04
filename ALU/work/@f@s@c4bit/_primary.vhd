library verilog;
use verilog.vl_types.all;
entity FSC4bit is
    port(
        a               : in     vl_logic_vector(3 downto 0);
        b               : in     vl_logic_vector(3 downto 0);
        bin             : in     vl_logic;
        diff            : out    vl_logic_vector(3 downto 0);
        bout            : out    vl_logic
    );
end FSC4bit;
