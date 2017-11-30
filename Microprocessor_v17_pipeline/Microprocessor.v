//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* Modulo do microprocessador */
module Microprocessor(CLK, RST);

	input CLK, RST;

	wire isImm, wenRB, wenIR, wenPC, jmpCond, escCondCP, escCP, isMul, sigHiLo, HiLOwb;
	wire [3:0] opCode, opA, opB, opC, opULA;
	wire [11:0] addrImm, progCounter;
	wire [15:0] regA, regB, res, outMuxImm, outMuxJmpBrc, outMuxPC;
	wire [2:0] flagReg;
	wire [15:0]	instr;
	wire [15:0] resHI, resLO;
	wire [15:0] regMul, dataIn;
	
	reg [15:0] PC;				// Program Counter	12-bit
	
	assign jmpCond = escCP | (escCondCP & flagReg[2]);		//flagReg[2]: ZeroBit
	assign progCounter = PC[11:0];
	
	
	
	//// Novos sinais
	
	wire decExeBufferWr;
	wire decExeHasWB;
	wire pcRegWr;
	wire regBankWr;
	wire exeWbBufferWr;
	wire fowardA;
	wire fowardB;
	wire [15:0] operandA;
	wire [15:0] operandB;
	
	/***** Buffer entre decodificacao e execucao	*/
	reg [3:0] DecExeBuffer_OpCode;
	reg [3:0] DecExeBuffer_OpA;
	reg [3:0] DecExeBuffer_OpB;
	reg [3:0] DecExeBuffer_OpC;
	reg [11:0] DecExeBuffer_Imm;
	reg DecExeBufferCtrl_IsImm;
	reg DecExeBufferCtrl_HasWB;
	reg [3:0] DecExeBufferCtrl_OpULA;
	
	/***** Buffer entre execucao e writeback	*/
	reg [15:0] ExeWbBuffer_Res;
	reg [2:0] ExeWbBuffer_FlagReg;
	reg [3:0] ExeWbBufferCtrl_RegDest;			// Registro que vai ser escrito
	reg ExeWbBufferCtrl_HasWB;						// Sinal de controle para WB para informar se deve ou nao escrever no banco de registro
	
	/* InstructionMemory: InstrMemory ( address,	clock, q) */
	InstrMemory instrMemory ( progCounter,	CLK, instr);
	
	/* Decoder: Decoder ( Instr, OpCode, OpA, OpB, OpC, AddrIm, OpULA, IsImm, HasWB); */
	Decoder instdecode(	instr,
								opCode,
								opA,
								opB,
								opC,
								addrImm,
								opULA,
								isImm,
								decExeHasWB );

	/* RegisterBank: RegisterBank ( CLK, RST, AddrRegA, AddrRegB, AddrWriteReg, Data, WEN, RegA, RegB ) */
	RegisterBank regBank(CLK,
								RST,
								DecExeBuffer_OpA,
								DecExeBuffer_OpB,
								ExeWbBufferCtrl_RegDest,
								ExeWbBuffer_Res,
								ExeWbBufferCtrl_HasWB& regBankWr,		// Precisa estar no estagio de escrita e precisa ter wb
								regA,
								regB );

	// Mux para encaminhamento do operando A
	Mux16bit2x1 muxFowardA(regA, ExeWbBuffer_Res, operandA, fowardA);
	
	// Mux para encaminhamento do operando B
	Mux16bit2x1 muxFowardB(regB, ExeWbBuffer_Res, operandB, fowardB);
								
	//-- Selecao de imediato ou Registro B		(A, B, S, SEL)
	Mux16bit2x1 muxOpImm(operandB,
								{ 12'h000, DecExeBuffer_OpB },
								outMuxImm,
								DecExeBufferCtrl_IsImm );
								
	/* ULA: ULA (OpA, OpB, Res, CodeULA, FlagReg); */
	ULA modULA(operandA, outMuxImm, res, DecExeBufferCtrl_OpULA, flagReg);

	/* Mult: Mult(A, B, HI, LO, EN, CLK); */
//	Mult mult(operandA, operandB, resHI, resLO, isMul, CLK);
	
	
	
	
	
	
	/* MUX: Mux16bit2x1 (A, B, S, SEL) */
	
//	Mux16bit2x1 muxJmpBrc(res, { PC[11:8], addrImm }, outMuxJmpBrc, escCP);
//	Mux16bit2x1 muxSourcePC(PC + 16'b1, outMuxJmpBrc, outMuxPC, jmpCond);
//	Mux16bit2x1 muxHiLo(resLO, resHI, regMul, sigHiLo);
//	Mux16bit2x1 muxDataRegBank(res, regMul, dataIn, HiLOwb);
	
	/* Control: Control (CLK, RS, DecExeBufferWr, PCRegWr, ExeWbBufferWr, RegBankWr) */
	Control ctrl(	CLK,
						RST,
						decExeBufferWr,
						pcRegWr,
						exeWbBufferWr,
						regBankWr,
						DecExeBuffer_OpA,
						DecExeBuffer_OpB,
						ExeWbBufferCtrl_RegDest,
						ExeWbBufferCtrl_HasWB,
						fowardA,
						fowardB );
	
	always @ (posedge CLK) begin
		if (RST) begin
			PC								<= 16'h0000;
			
			DecExeBuffer_OpCode		<= 4'b0;
			DecExeBuffer_OpA			<=	4'b0;
			DecExeBuffer_OpB			<= 4'b0;
			DecExeBuffer_OpC			<= 4'b0;
			DecExeBuffer_Imm			<= 12'b0;
			DecExeBufferCtrl_OpULA	<= 4'b0;		// Mudar para NOP
			DecExeBufferCtrl_IsImm	<= 1'b0;
			DecExeBufferCtrl_HasWB	<= 1'b0;
			
			ExeWbBuffer_Res			<= 16'b0;
			ExeWbBuffer_FlagReg		<= 3'b0;
			ExeWbBufferCtrl_HasWB	<= 1'b0;
			ExeWbBufferCtrl_RegDest	<= 4'b0;
		end
		else begin
			// Atualizacao do PC
			if (pcRegWr) begin
				PC <= PC + 1;	// outMuxPC;
			end
			
			// Atualizacao do buffer dec/exe
			if (decExeBufferWr) begin
				DecExeBuffer_OpCode		<= opCode;
				DecExeBuffer_OpA			<=	opA;
				DecExeBuffer_OpB			<= opB;
				DecExeBuffer_OpC			<= opC;
				DecExeBuffer_Imm			<= addrImm;
				DecExeBufferCtrl_IsImm	<= isImm;
				DecExeBufferCtrl_HasWB	<= decExeHasWB;
				DecExeBufferCtrl_OpULA	<= opULA;
			end
			
			// Atualizacao do buffer exe/wb
			if (exeWbBufferWr) begin
				ExeWbBuffer_Res			<= res;
				ExeWbBuffer_FlagReg		<= flagReg;
				ExeWbBufferCtrl_HasWB	<= DecExeBufferCtrl_HasWB;		// Apenas faz o forward
				ExeWbBufferCtrl_RegDest	<= DecExeBuffer_OpC;				// Mantem endereço do registro que vai ser escrito
			end
		end
	end
endmodule
