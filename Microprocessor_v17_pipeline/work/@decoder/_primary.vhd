library verilog;
use verilog.vl_types.all;
entity Decoder is
    port(
        Instr           : in     vl_logic_vector(15 downto 0);
        OpCode          : out    vl_logic_vector(3 downto 0);
        OpA             : out    vl_logic_vector(3 downto 0);
        OpB             : out    vl_logic_vector(3 downto 0);
        OpC             : out    vl_logic_vector(3 downto 0);
        AddrImm         : out    vl_logic_vector(11 downto 0);
        CLK             : in     vl_logic;
        EN              : in     vl_logic
    );
end Decoder;
