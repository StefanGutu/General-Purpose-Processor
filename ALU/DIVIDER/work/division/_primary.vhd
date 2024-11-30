library verilog;
use verilog.vl_types.all;
entity division is
    generic(
        WIDTH           : integer := 16
    );
    port(
        A               : in     vl_logic_vector;
        B               : in     vl_logic_vector;
        Res             : out    vl_logic_vector;
        remainder       : out    vl_logic_vector
    );
end division;
