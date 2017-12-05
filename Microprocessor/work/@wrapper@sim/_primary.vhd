library verilog;
use verilog.vl_types.all;
entity WrapperSim is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        RDY             : out    vl_logic;
        START           : in     vl_logic
    );
end WrapperSim;
