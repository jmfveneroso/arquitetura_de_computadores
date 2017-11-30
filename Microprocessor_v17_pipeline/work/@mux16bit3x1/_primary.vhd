library verilog;
use verilog.vl_types.all;
entity Mux16bit3x1 is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(15 downto 0);
        C               : in     vl_logic_vector(15 downto 0);
        S               : out    vl_logic_vector(15 downto 0);
        SEL             : in     vl_logic_vector(1 downto 0)
    );
end Mux16bit3x1;
