library verilog;
use verilog.vl_types.all;
entity ULA is
    generic(
        InsADD          : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi0);
        InsSUB          : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi0, Hi1);
        InsSLT          : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi0);
        InsAND          : vl_logic_vector(0 to 3) := (Hi0, Hi0, Hi1, Hi1);
        InsOR           : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi0);
        InsXOR          : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi0, Hi1);
        InsBEZ          : vl_logic_vector(0 to 3) := (Hi0, Hi1, Hi1, Hi0);
        OverflowFlag    : integer := 0;
        NegFlag         : integer := 1;
        ZeroFlag        : integer := 2
    );
    port(
        OpA             : in     vl_logic_vector(15 downto 0);
        OpB             : in     vl_logic_vector(15 downto 0);
        Res             : out    vl_logic_vector(15 downto 0);
        CodeULA         : in     vl_logic_vector(3 downto 0);
        FlagReg         : out    vl_logic_vector(2 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of InsADD : constant is 1;
    attribute mti_svvh_generic_type of InsSUB : constant is 1;
    attribute mti_svvh_generic_type of InsSLT : constant is 1;
    attribute mti_svvh_generic_type of InsAND : constant is 1;
    attribute mti_svvh_generic_type of InsOR : constant is 1;
    attribute mti_svvh_generic_type of InsXOR : constant is 1;
    attribute mti_svvh_generic_type of InsBEZ : constant is 1;
    attribute mti_svvh_generic_type of OverflowFlag : constant is 1;
    attribute mti_svvh_generic_type of NegFlag : constant is 1;
    attribute mti_svvh_generic_type of ZeroFlag : constant is 1;
end ULA;
