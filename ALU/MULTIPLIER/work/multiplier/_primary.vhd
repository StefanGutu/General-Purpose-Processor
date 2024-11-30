library verilog;
use verilog.vl_types.all;
entity multiplier is
    generic(
        N               : integer := 16
    );
    port(
        \out\           : out    vl_logic_vector;
        a_in            : in     vl_logic_vector;
        b_in            : in     vl_logic_vector;
        clk             : in     vl_logic;
        start           : in     vl_logic;
        reset           : in     vl_logic;
        finish          : out    vl_logic
    );
end multiplier;
