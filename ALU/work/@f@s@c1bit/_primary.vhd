library verilog;
use verilog.vl_types.all;
entity FSC1bit is
    port(
        a               : in     vl_logic;
        b               : in     vl_logic;
        bin             : in     vl_logic;
        diff            : out    vl_logic;
        bout            : out    vl_logic
    );
end FSC1bit;
