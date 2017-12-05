library verilog;
use verilog.vl_types.all;
entity Mult is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(15 downto 0);
        S               : out    vl_logic_vector(31 downto 0);
        EN              : in     vl_logic;
        CLK             : in     vl_logic
    );
end Mult;
