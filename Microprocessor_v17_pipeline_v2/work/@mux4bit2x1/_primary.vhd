library verilog;
use verilog.vl_types.all;
entity Mux4bit2x1 is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        S               : out    vl_logic_vector(3 downto 0);
        SEL             : in     vl_logic
    );
end Mux4bit2x1;
