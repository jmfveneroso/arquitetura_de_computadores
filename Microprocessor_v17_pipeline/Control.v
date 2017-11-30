//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* Controle do microprocessador */
module Control (	CLK,
						RST,
						DecExeBufferWr,
						PCRegWr,
						ExeWbBufferWr,
						RegBankWr,
						RegOpA,
						RegOpB,
						RegDestWB,
						HasWB,
						FowardA,
						FowardB
					);
	
	input CLK, RST;
	
//	input [3:0] OpCode;				// OpCode da instruçao atual
//	output reg [3:0] ULA_OP;		// Codigo de operaçao da ULA
	
//	output reg ULA_B;					// Sinal do Mux para operando B da ULA: Imediato ou RegB		{0: RegB; 1: Imm}
	
//	output reg EscCondCP;			// Sinal de instruçao de 'Branch'
//	output reg EscCP;					// Sinal de escrita no registrador PC
//	output reg EscIR;					// Sinal de leitura da memoria de instruçoes						(RD InstrMem)
//	output reg EscReg;				// Sinal de escrita no banco de registradores					(WEN RegBank)
//	output reg WEnPC;					// Habilita escrita no PC
//	output reg IsMulWB;				// Habilita multiplicacao
//	output reg HILO;					// Sinal para registro HI ou LO
//	output reg HILO_WB;				// Sinal para escrita do HILO
	
	
	// Novos sinais
	//-- Sinais Decode
	output reg DecExeBufferWr;		// Sinal para escrever no buffer entre decodificacao e execucao
	output reg PCRegWr;				// Sinal para escrever no registrador PC
	
	//-- Sinais Execute
	output reg ExeWbBufferWr;		// Sinal para escrever no buffer entre execucao e writeback
	
	//-- Sinais Writeback
	output reg RegBankWr;			// Sinal para escrever no banco de registradores
	
	input [3:0] RegDestWB;			// Endereco de reg de destino do wb
	input [3:0] RegOpA;				// Endereco de reg A da instrucao atual
	input [3:0] RegOpB;				// Endereco de reg B da instrucao atual
	input HasWB;						// Sinal que indica se a instrucao faz writeback
	output reg FowardA;				// Sinal que indica o encaminhamento do writeback para o operando A
	output reg FowardB;				// Sinal que indica o encaminhamento do writeback para o operando B
	
	
	reg [1:0] DecodeState;			// Estado da maquina de decode
											// 0: Busca instrucao na memoria
											// 1: Decodifica e escreve no buffer DEC/EXE
											// 2: Stall
											
	reg [1:0] ExecutionState;		// Estado da maquina de execucao
											// 0: Busca de registros
											// 1: Execucao
											// 2: Stall
											
	reg [1:0] WriteBackState;		// Estado da maquina de writeback
											// 0: Escreve no banco
											// 1: idle
											// 2: Stall
	
	parameter DEC0 = 2'b00, DEC1 = 2'b01, DEC2 = 2'b10;
	parameter EXE0 = 2'b00, EXE1 = 2'b01, EXE2 = 2'b10;
	parameter WB0 = 2'b00, WB1 = 2'b01, WB2 = 2'b10;
	
	/* Codigo de Instruçoes da maquina */
	parameter InsADD  = 4'b0000;	// ADD	$s4, $s3, $s2
	parameter InsSUB  = 4'b0001;	//	SUB	$s4, $s3, $s2
	parameter InsSLTI = 4'b0010;	//	SLTI	$s4, imm, $s2
	parameter InsAND  = 4'b0011;	//	AND 	$s4, $s3, $s2
	parameter InsOR   = 4'b0100;	//	OR 	$s4, $s3, $s2
	parameter InsXOR  = 4'b0101;	//	XOR 	$s4, $s3, $s2
	parameter InsANDI = 4'b0110;	//	ANDI 	$s4, imm, $s2
	parameter InsORI  = 4'b0111;	//	ORI 	$s4, imm, $s2
	parameter InsXORI = 4'b1000;	//	XORI 	$s4, imm, $s2
	parameter InsADDI = 4'b1001;	//	ADDI 	$s4, imm, $s2
	parameter InsSUBI = 4'b1010;	//	SUBI 	$s4, imm, $s2
	parameter InsJ		= 4'b1011;	// J		imm
	parameter InsBEZ	= 4'b1100;	//	BEZ	, $s3, $s2
	parameter InsMUL	= 4'b1101;	// MUL	-, $s3, $s2
	parameter InsGHI	= 4'b1110;	// GHI	$s4, , 
	parameter InsGLO	= 4'b1111;	// GLO	$s4, , 
	
	/* Codigo de operaçoes da ALU */
	parameter ULAADD = 4'b0000;	// ADD
	parameter ULASUB = 4'b0001;	//	SUB
	parameter ULASLT = 4'b0010;	//	SLTI
	parameter ULAAND = 4'b0011;	//	AND
	parameter ULAOR =  4'b0100;	//	OR
	parameter ULAXOR = 4'b0101;	//	XOR
	parameter ULABEZ = 4'b0110;	// BEZ
	parameter ULANOP = 4'b0111;	// NOP
	
	
	/* Maquina de estados para a Decodificacao */
	always @ (posedge CLK) begin
		if ( RST ) begin
			DecodeState <= DEC0;
		end
		else begin
			case (DecodeState)
				DEC0: DecodeState <= DEC1;
				DEC1: DecodeState <= DEC0;
				DEC2: DecodeState <= DEC2;
			endcase
		end
	end
	
	/* Maquina de estados para a Execucao */
	always @ (posedge CLK) begin
		if ( RST ) begin
			ExecutionState <= EXE0;
		end
		else begin
			case (ExecutionState)
				EXE0: ExecutionState <= EXE1;
				EXE1: ExecutionState <= EXE0;
				EXE2: ExecutionState <= EXE2;
			endcase
		end
	end
	
	/* Maquina de estados para a Writeback */
	always @ (posedge CLK) begin
		if ( RST ) begin
			WriteBackState <= WB0;
		end
		else begin
			case (WriteBackState)
				WB0: WriteBackState <= WB1;
				WB1: WriteBackState <= WB0;
				WB2: WriteBackState <= WB2;
			endcase
		end
	end
	
	// Decodificacao responsavel por buscar instrucao na memoria,
	// atualizar buffer do pipeline Dec/Exe e atualizar registro PC
	
	/* Sinais para mudancas nos estados de decode */
	always @ (*) begin
		case (DecodeState)
			DEC0: begin
				// Busca de instrucao na memoria
				DecExeBufferWr		<= 1'b0;
				PCRegWr				<= 1'b0;
				
			end
			DEC1: begin
				// Decodificacao e armazenamento no buffer 
				DecExeBufferWr		<= 1'b1;
				PCRegWr				<= 1'b1;
			
			end
			DEC2: begin
				// Stall
				DecExeBufferWr		<= 1'b0;
				PCRegWr				<= 1'b0;
				
			end
		endcase
	end
	
	// Execucao responsavel por encaminhar registros para ula e mult
	// e executar operacoes na ula e mult, testar branches
	
	/* Sinais para mudancas nos estados de execucao */
	always @ (*) begin
		case (ExecutionState)
			EXE0: begin
				// Busca de registradores
				ExeWbBufferWr		<= 1'b0;
				
			end
			EXE1: begin
				// Execucao e armazenamento no buffer
				ExeWbBufferWr		<= 1'b1;
				
			end
			EXE2: begin
				// Stall
				ExeWbBufferWr		<= 1'b0;
				
			end
		endcase
	end
	
	// Writeback responsavel por escrever o resultado da instrucao
	// no banco de registradores
	
	/* Sinais para mudancas nos estados de writeback */
	always @ (*) begin
		case (WriteBackState)
			WB0: begin
				// Grava no banco de registradores
				RegBankWr			<= 1'b1;
			end
			WB1: begin
				// Estado idle
				RegBankWr			<= 1'b0;
			end
			WB2: begin
				// Stall
				RegBankWr			<= 1'b0;
			end
		endcase
	end
	
	/* Fowarding para A e B */
	always @ (*) begin
		if ( (RegDestWB == RegOpA) && HasWB ) begin
			FowardA <= 1'b1;
		end else begin
			FowardA <= 1'b0;
		end
		
		if ( (RegDestWB == RegOpB) && HasWB) begin
			FowardB <= 1'b1;
		end else begin
			FowardB <= 1'b0;
		end
	end
	
endmodule
