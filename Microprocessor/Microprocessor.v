//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017


/*						ATENÇAO!!!!

		Se tiver problemas para carregar arquivo de inicializaçao de memoria alterar caminho
		no arquivo "InstrMemory.v" !!!!!!
*/




/* Modulo do microprocessador */
module Microprocessor(CLK, RST);

	input CLK, RST;

	wire isImm, wenRB, wenIR, wenPC, jmpCond, escCondCP, escCP, isMul, sigHiLo, HiLOwb;
	wire [3:0] opCode, opA, opB, opC, opALU;
	wire [11:0] addrImm, progCounter;
	wire [15:0] regA, regB, res, outMuxImm, outMuxJmpBrc, outMuxPC;
	wire [2:0] flagReg;
	wire [15:0]	instr;
	wire [15:0] resHI, resLO;
	wire [15:0] regMul, dataIn;
	
	reg [15:0] PC;				// Program Counter	12-bit
	
	assign jmpCond = escCP | (escCondCP & flagReg[2]);		//flagReg[2]: ZeroBit
	assign progCounter = PC[11:0];
	
	/* InstructionMemory: InstrMemory ( address,	clock, q) */
	InstrMemory instrMemory ( progCounter,	CLK, instr);
	
	/* Decoder: Decoder ( Instr, OpCode, OpA, OpB, OpC, AddrImm, CLK, EN ); */
	Decoder instdecode(instr, opCode, opA, opB, opC, addrImm, CLK, wenIR);

	/* RegisterBank: RegisterBank ( AddrRegA[3:0], AddrRegB[3:0], AddrWriteReg[3:0], Data[15:0], WEN, CLK, RST, RegA[15:0]], RegB[15:0] ) */
	RegisterBank regBank(opA, opB, opC, dataIn, wenRB, CLK, RST, regA, regB);

	/* ULA: ULA (OpA, OpB, Res, CodeULA, FlagReg); */
	ULA modULA(regA, outMuxImm, res, opALU, flagReg);

	/* Mult: Mult(A, B, HI, LO, EN, CLK); */
	Mult mult(regA, regB, resHI, resLO, isMul, CLK);
	
	/* MUX: Mux16bit2x1 (A, B, S, SEL) */
	Mux16bit2x1 muxOpImm(regB, { 12'h000, opB }, outMuxImm, isImm);
	Mux16bit2x1 muxJmpBrc(res, { PC[11:8], addrImm }, outMuxJmpBrc, escCP);
	Mux16bit2x1 muxSourcePC(PC + 16'b1, outMuxJmpBrc, outMuxPC, jmpCond);
	Mux16bit2x1 muxHiLo(resLO, resHI, regMul, sigHiLo);
	Mux16bit2x1 muxDataRegBank(res, regMul, dataIn, HiLOwb);
	
	/* Control: Control (OpCode, ULA_OP, ULA_B, EscIR, EscCondCP, EscCP, EscReg, WEnPC, IsMul, HILO, HILO_WB, CLK, RST ) */
	Control ctrl(opCode, opALU, isImm, wenIR, escCondCP, escCP, wenRB, wenPC, isMul, sigHiLo, HiLOwb, CLK, RST );
	
	always @ (posedge CLK) begin
		if (RST) begin
			PC <= 16'h0000;
		end
		else begin
			if (wenPC) begin
				PC <= outMuxPC;
			end
		end
	end
endmodule
