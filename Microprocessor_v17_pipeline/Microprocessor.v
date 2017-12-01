//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* Modulo do microprocessador */
module Microprocessor(CLK, RST);

	input CLK, RST;

	
	
	/*			Registradores		*/
	reg [15:0]	PC;										// Program Counter
	reg			FowardA, FowardB;						// Sinais de controle para encaminhamento
	
	//-- Buffer entre decodificacao e execucao (Dec/Exe)
	reg [3:0]	DecExeBuffer_OpA;
	reg [3:0]	DecExeBuffer_OpB;
	reg [3:0]	DecExeBuffer_OpC;
	reg [3:0]	DecExeBuffer_OpULA;
	reg [11:0]	DecExeBufferCtrl_AddrImm;
	reg			DecExeBufferCtrl_IsImm;
	reg			DecExeBufferCtrl_HasWB;
	reg			DecExeBufferCtrl_HasStall;
	reg			DecExeBufferCtrl_IsJump;
	
	//-- Buffer entre execucao e writeback (Exe/WB)
	reg [15:0]	ExeWBBuffer_Res;
	reg [2:0]	ExeWBBuffer_FlagReg;
	reg [3:0]	ExeWBBufferCtrl_RegDest;
	reg [11:0]	ExeWBBufferCtrl_AddrImm;
	reg 			ExeWBBufferCtrl_HasWB;
	reg			ExeWBBufferCtrl_HasJumped;
	reg			ExeWBBufferCtrl_HasStall;
			
	
	
	//-- Wires
	wire [15:0]	instr;
	wire [11:0]	progCounter;
	wire [3:0]	opCode, opA, opB, opC, opULA;
	wire [11:0]	addrImm;
	wire			isImm;									
	wire			hasWB;								
	wire			hasStall;
	wire			isJump;
	
	wire			decExeBufferWr;						// Sinal para escrita no buffer do pipe Dec/Exe
	wire			exeWBBufferWr;							// Sinal para escrita no buffer do pipe Exe/WB
	wire			pcRegWr;									// Sinal para escrita no PC
	wire			regBankWr;								// Sinal para escrita no RegisterBank
	
	wire			isDecStall;
	wire			clrStall;								// Sinal para tirar stall do decode
	wire			hasJumped;								// Sinal que indica se o salto da instrucao aconteceu
	wire			updateJmpPC;
	
	wire [15:0]	pcExtSrc;								// Valor do PC vindo externo
	wire [15:0] newPC;									// Saida do Mux de selecao do PC
	
	wire [15:0] regA, regB;								// Saidas do banco de registradores
	wire [15:0]	operandA, operandB;					// Operandos utilizados pela ULA
	wire [15:0] res;										// Resultado da ULA
	wire [2:0]	flagReg;									// Flags da ULA
	wire [15:0]	outMuxImm;								// Saida do mux de selecao de operando ou imediato
	
	
	assign progCounter = PC[11:0];
	
	// Indica se houve o jump, utilizado para tirar o estagio de decodificacao de stall
	assign hasJumped = (DecExeBufferCtrl_IsJump & isDecStall ) | ( DecExeBufferCtrl_HasStall & flagReg[2] & exeWBBufferWr);
	
	/*			 Instancias 		*/
	
	//-- Memoria de Instrucao
	InstrMemory instrMemory ( progCounter,	CLK, instr);
	
	//-- Decodificador de instrucoes
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

	//-- Banco de Registradores
	RegisterBank regBank(CLK,
								RST,
								DecExeBuffer_OpA,
								DecExeBuffer_OpB,
								ExeWBBufferCtrl_RegDest,
								ExeWBBuffer_Res,
								ExeWBBufferCtrl_HasWB& regBankWr,
								regA,
								regB );
							
							
	ULA modULA(	operandA,
					outMuxImm,
					res,
					DecExeBuffer_OpULA,
					flagReg );
	
	//-- Maquina de estados para controle do estagio de decodificacao
	ControlDecode ctrlDecode (	CLK,
										RST,
										decExeBufferWr,
										pcRegWr,
										hasStall,
										clrStall,
										isDecStall	);
	
	//-- Maquina de estados para controle do estagio de execucao
	ControlExecute ctrlExecute (	CLK,
											RST,
											exeWBBufferWr );

	//-- Maquina de estados para controle do estagio de writeback
	ControlWriteback ctrlWriteback(	CLK,
												RST,
												regBankWr,
												clrStall,
												ExeWBBufferCtrl_HasJumped,
												ExeWBBufferCtrl_HasStall,
												updateJmpPC);
	
	//-- Mux de selacao da origem do PC
	Mux16bit2x1 muxPCSource(	PC + 16'b1,
										pcExtSrc,
										newPC,
										ExeWBBufferCtrl_HasJumped & isDecStall	);							
	
	//-- Mux para encaminhamento do operando A
	Mux16bit2x1 muxFowardA(	regA,
									ExeWBBuffer_Res,
									operandA,
									FowardA	);
	
	//-- Mux para encaminhamento do operando B
	Mux16bit2x1 muxFowardB(	regB,
									ExeWBBuffer_Res,
									operandB,
									FowardB	);
									
	//-- Mux para selecao imediato ou Registro B
	Mux16bit2x1 muxOpImm(	operandB,
									{ 12'h000, DecExeBuffer_OpB },
									outMuxImm,
									DecExeBufferCtrl_IsImm );
	
	//-- Mux para selecao de endereco externo do PC (Jump ou Branch)
	Mux16bit2x1 muxExtPCSrc(	ExeWBBuffer_Res,
										{ 4'b0, ExeWBBufferCtrl_AddrImm },
										pcExtSrc,
										DecExeBufferCtrl_IsJump );
	
	
	always @ (posedge CLK) begin
		if (RST) begin
			PC									<= 16'b0;
			
			DecExeBuffer_OpA				<= 4'b0;
			DecExeBuffer_OpB				<= 4'b0;
			DecExeBuffer_OpC				<= 4'b0;
			DecExeBuffer_OpULA			<= 4'b0;
			DecExeBufferCtrl_AddrImm	<= 12'b0;
			DecExeBufferCtrl_IsImm		<= 1'b0;
			DecExeBufferCtrl_HasWB		<= 1'b0;
			DecExeBufferCtrl_HasStall	<= 1'b0;
			DecExeBufferCtrl_IsJump		<= 1'b0;
			
			ExeWBBuffer_Res					<= 16'b0;
			ExeWBBuffer_FlagReg				<= 3'b0;
			ExeWBBufferCtrl_RegDest			<= 4'b0;
			ExeWBBufferCtrl_HasWB			<= 1'b0;
			ExeWBBufferCtrl_AddrImm			<= 12'b0;
			ExeWBBufferCtrl_HasJumped		<= 1'b0;
		end
		else begin
			// Atualiza PC
			if (pcRegWr | updateJmpPC) begin									
				PC									<= newPC;
			end
			
			// Atualiza o buffer Dec/Exe
			if (decExeBufferWr) begin
				DecExeBuffer_OpA				<= opA;
				DecExeBuffer_OpB				<= opB;
				DecExeBuffer_OpC				<= opC;
				DecExeBuffer_OpULA			<= opULA;
				DecExeBufferCtrl_AddrImm	<= addrImm;
				DecExeBufferCtrl_IsImm		<= isImm;
				DecExeBufferCtrl_HasWB		<= hasWB;
				DecExeBufferCtrl_HasStall	<= hasStall;
				DecExeBufferCtrl_IsJump		<= isJump;
			end
			
			// Atualiza o buffer Exe/WB
			if (exeWBBufferWr) begin
				ExeWBBuffer_Res					<= res;
				ExeWBBuffer_FlagReg				<= flagReg;
				ExeWBBufferCtrl_RegDest			<= DecExeBuffer_OpC;
				ExeWBBufferCtrl_HasWB			<= DecExeBufferCtrl_HasWB;
				ExeWBBufferCtrl_AddrImm			<= DecExeBufferCtrl_AddrImm;
				ExeWBBufferCtrl_HasJumped		<= hasJumped;
				ExeWBBufferCtrl_HasStall		<= DecExeBufferCtrl_HasStall;
			end
		end
	end
	
	/* Fowarding para A e B */
	always @ (*) begin
		if ( (ExeWBBufferCtrl_RegDest == DecExeBuffer_OpA) && ExeWBBufferCtrl_HasWB ) begin
			FowardA <= 1'b1;
		end else begin
			FowardA <= 1'b0;
		end
		
		if ( (ExeWBBufferCtrl_RegDest == DecExeBuffer_OpB) && ExeWBBufferCtrl_HasWB) begin
			FowardB <= 1'b1;
		end else begin
			FowardB <= 1'b0;
		end
	end
	
endmodule
