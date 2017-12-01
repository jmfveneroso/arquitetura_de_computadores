//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/*
	Modulo para teste dos estagios do pipeline separados
*/
module TestStageExecution(	CLK,
						RST	);
						
	input CLK, RST;
	
	/*				Setup atual: Estagio de decodificacao				*/

	
	wire decExeBufferWr, pcRegWr, clrStallDec, isDecStall;
	wire [3:0] opCode, opA, opB, opC, opULA;
	wire [11:0] addrImm;
	wire isImm, hasWB, hasStall, hasJumped, pcSrc, isJump;
	
	wire [11:0] progCounter;
	wire [15:0] instr;
	wire [15:0] newPC, pcExtSrc;
	
	reg [15:0] PC;
	reg [15:0] Instruction;
	
	assign progCounter = PC[11:0];
	
	/***** Buffer entre decodificacao e execucao	*/
	reg [3:0]	DecExeBuffer_OpCode;
	reg [3:0]	DecExeBuffer_OpA;
	reg [3:0]	DecExeBuffer_OpB;
	reg [3:0]	DecExeBuffer_OpC;
	reg [11:0]	DecExeBuffer_Imm;					// Remover?
	reg			DecExeBufferCtrl_IsImm;
	reg			DecExeBufferCtrl_HasWB;
	reg			DecExeBufferCtrl_HasStall;
	reg			DecExeBufferCtrl_IsJmp;
	reg [3:0]	DecExeBufferCtrl_OpULA;
	
	ControlDecode ctrlDecode (	CLK,
										RST,
										decExeBufferWr,
										pcRegWr,
										hasStall,
										clrStallDec,
										isDecStall,
										hasJumped,
										pcSrc );
	
	InstrMemory instrMemory ( progCounter,	CLK, instr);
	
	Decoder decoder (	instr,
							opCode,
							opA,
							opB,
							opC,
							addrImm,
							opULA,
							isImm,
							hasWB,
							hasStall,
							isJump	);
							
	Mux16bit2x1 muxPCSource(PC + 16'b1, pcExtSrc, newPC, pcSrc);
	
	always @ (posedge CLK) begin
	
		if (RST) begin
			PC									<= 16'b0;
			
			DecExeBuffer_OpCode			<= 4'b0;
			DecExeBuffer_OpA				<= 4'b0;
			DecExeBuffer_OpB				<= 4'b0;
			DecExeBuffer_OpC				<= 4'b0;
			DecExeBuffer_Imm				<= 12'b0;
			DecExeBufferCtrl_IsImm		<= 1'b0;
			DecExeBufferCtrl_IsJmp		<= 1'b0;
			DecExeBufferCtrl_HasWB		<= 1'b0;
			DecExeBufferCtrl_HasStall	<= 1'b0;
			DecExeBufferCtrl_OpULA		<= 4'b0;
		end
		else begin
			if ( pcRegWr ) begin
				PC				<= newPC;
			end
			
			if ( decExeBufferWr ) begin
				DecExeBuffer_OpCode			<= opCode;
				DecExeBuffer_OpA				<= opA;
				DecExeBuffer_OpB				<= opB;
				DecExeBuffer_OpC				<= opC;
				DecExeBuffer_Imm				<= addrImm;
				DecExeBufferCtrl_IsImm		<= isImm;
				DecExeBufferCtrl_IsJmp		<= isJump;
				DecExeBufferCtrl_HasWB		<= hasWB;
				DecExeBufferCtrl_HasStall	<= hasStall;
				DecExeBufferCtrl_OpULA		<= opULA;
			end
			
		end
	end
endmodule


/*				Setup: Estagio de execucao				*/
module TestStage(	CLK,
									RST );
	
	input CLK, RST;

// instanciar ula e mult	
	
	wire [3:0]	DecExeBuffer_OpA;
	wire [3:0]	DecExeBuffer_OpB;
	wire [3:0]	DecExeBuffer_OpC;
	wire [3:0]	DecExeBuffer_OpULA;
	wire [11:0]	DecExeBuffer_Imm;
	wire			DecExeBufferCtrl_IsImm;
	wire			DecExeBufferCtrl_IsJmp;
	wire 			DecExeBufferCtrl_HasWB;
	wire			DecExeBufferCtrl_HasStall;
	
	wire			fowardA;
	wire			fowardB;
	
	reg [3:0]	ExeWBBufferCtrl_RegDest;
	reg [15:0]	ExeWBBuffer_Res;
	reg [2:0] 	ExeWBBuffer_FlagReg;
	reg 			ExeWBBufferCtrl_HasWB;
	
	wire [15:0] operandA, operandB, regA, regB, outMuxImm, res;
	wire [2:0] flagReg;
	
	wire exeWBBufferWr;
	wire regBankWr;
	wire hasJumped;
	
	assign hasJumped = (flagReg[2] & DecExeBufferCtrl_HasStall) | DecExeBufferCtrl_IsJmp;
	
	ControlExecute ctrlExecute(	CLK,
											RST,
											exeWBBufferWr );

	RegisterBank regBank(CLK,
								RST,
								DecExeBuffer_OpA,
								DecExeBuffer_OpB,
								ExeWBBufferCtrl_RegDest,
								ExeWBBuffer_Res,
								ExeWBBufferCtrl_HasWB& regBankWr,		// Precisa estar no estagio de escrita e precisa ter wb
								regA,
								regB );
								
	ULA modULA(	operandA,
					outMuxImm,
					res,
					DecExeBuffer_OpULA,
					flagReg );
	
	// Mux para encaminhamento do operando A
	Mux16bit2x1 muxFowardA(	regA,
									ExeWBBuffer_Res,
									operandA,
									fowardA	);
	
	// Mux para encaminhamento do operando B
	Mux16bit2x1 muxFowardB(	regB,
									ExeWBBuffer_Res,
									operandB,
									fowardB	);
	
	//-- Selecao de imediato ou Registro B		(A, B, S, SEL)
	Mux16bit2x1 muxOpImm(	operandB,
									{ 12'h000, DecExeBuffer_OpB },
									outMuxImm,
									DecExeBufferCtrl_IsImm );
	
	always @ (posedge CLK) begin
		if (RST) begin
			ExeWBBufferCtrl_RegDest			<= 4'b0;
			ExeWBBuffer_Res					<= 4'b0;
			ExeWBBufferCtrl_HasWB			<= 1'b0;
			ExeWBBuffer_FlagReg				<= 3'b0;
		end
		else begin
			if (exeWBBufferWr) begin
				ExeWBBuffer_Res				<= res;
				ExeWBBuffer_FlagReg			<= flagReg;
				ExeWBBufferCtrl_RegDest		<= DecExeBuffer_OpC;
				ExeWBBufferCtrl_HasWB		<= DecExeBufferCtrl_HasWB;
			end
		end
	end
endmodule

