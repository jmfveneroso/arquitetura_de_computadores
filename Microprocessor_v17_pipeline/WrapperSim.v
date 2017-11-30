//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/*	Utilidades para simulaç~ao no ModelSIM
	exec vmake work > Makefile

	#Run it to compile what needs to be compiled
	make

	#Start simulation
	vsim -L altera_mf_ver -L lpm_ver -L cycloneiii_ver -L cycloneii_ver WrapperSim
*/

/* Wrapper para simulaçao do ULA */
module WrapperSim(CLK, RST, RDY, START);

	input CLK, RST, START;
	output RDY;

	wire isImm, isValid, wen;
	wire [3:0] opCode, opA, opB, opC, opALU;
	wire [11:0] addrImm;
	wire [15:0] regA, regB, res, outMux;
	wire [2:0] flagReg;
	wire [15:0]	instr;
	
	reg [11:0] PC;				// Program Counter	12-bit
	
	/* InstructionMemory: InstrMemory ( address,	clock, q) */
//	InstrMemory instrMemory ( PC,	CLK, instr);
	
	/* Decoder: Decoder ( Instr, OpCode, OpA, OpB, OpC, AddrImm, CLK ) */
//	Decoder instdecode(instr, opCode, opA, opB, opC, addrImm, CLK);

	/* RegisterBank: RegisterBank ( AddrRegA[3:0], AddrRegB[3:0], AddrWriteReg[3:0], Data[15:0], WEN, CLK, RST, RegA[15:0]], RegB[15:0] ) */
	RegisterBank regBank(opA, opB, opC, res, wen, CLK, RST, regA, regB);

	/* ULA: ULA (OpA, OpB, Res, Op, FlagReg) */
	ULA modULA(regA, outMux, res, opALU, flagReg);

	/* MUX: Mux16bit2x1 (A, B, S, SEL) */
	Mux16bit2x1 muxOpImm(regB, { 12'h000, opB }, outMux, isImm);

	/* Control: Control (CLK, RST, Start, Ready, Wen, Go) */
//	Control ctrl(CLK, RST, START, RDY, wen, 1'b1);

	always @ (posedge CLK) begin
		if (RST) begin
			PC <= 12'h0000;
		end
		else begin

		end
	end

endmodule
