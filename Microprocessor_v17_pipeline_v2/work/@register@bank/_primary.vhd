library verilog;
use verilog.vl_types.all;
entity RegisterBank is
    port(
        AddrRegA        : in     vl_logic_vector(3 downto 0);
        AddrRegB        : in     vl_logic_vector(3 downto 0);
        AddrWriteReg    : in     vl_logic_vector(3 downto 0);
        Data            : in     vl_logic_vector(15 downto 0);
        WEN             : in     vl_logic;
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        RegA            : out    vl_logic_vector(15 downto 0);
        RegB            : out    vl_logic_vector(15 downto 0)
    );
end RegisterBank;
