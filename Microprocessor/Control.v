//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* Controle do microprocessador */
module Control (OpCode, ULA_OP, ULA_B, EscIR, EscCondCP, EscCP, EscReg, WEnPC, IsMulWB, HILO, HILO_WB, CLK, RST );
	
	input CLK, RST;
	
	input [3:0] OpCode;				// OpCode da instruçao atual
	output reg [3:0] ULA_OP;		// Codigo de operaçao da ULA
	
	output reg ULA_B;					// Sinal do Mux para operando B da ULA: Imediato ou RegB		{0: RegB; 1: Imm}
	
	output reg EscCondCP;			// Sinal de instruçao de 'Branch'
	output reg EscCP;					// Sinal de escrita no registrador PC
	output reg EscIR;					// Sinal de leitura da memoria de instruçoes						(RD InstrMem)
	output reg EscReg;				// Sinal de escrita no banco de registradores					(WEN RegBank)
	output reg WEnPC;					// Habilita escrita no PC
	output reg IsMulWB;				// Habilita multiplicacao
	output reg HILO;					// Sinal para registro HI ou LO
	output reg HILO_WB;				// Sinal para escrita do HILO
	
	reg [2:0] State;
	
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
	parameter InsMUL	= 4'b1101;	// MUL	$s4, $s3, $s2
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
	
	/* Definiçao de estados da maquina de estados */
	parameter IF = 3'b000, ID = 3'b001, RF = 3'b010, EX = 3'b011, WB = 3'b100;
	
	/* Maquina de estados, mudança de estados */
	always @(posedge CLK) begin
		if ( RST ) begin
			State <= IF;
		end
		else begin
			case (State)
				IF: State <= ID;		/* Instruction Fetch */
				ID: State <= RF;		/* Instruction Decode */
				RF: State <= EX;		/* Register Fetch */
				EX: State <= WB;		/* Execution */
				WB: State <= IF;		/* WriteBack */
				default: State <= IF;
			endcase
		end
	end
	
	/* Maquina de estados, mudança de saidas */
	always @(State) begin
		case (State)
			IF: begin					/* Instruction Fetch */
				EscIR		<= 1'b0;
				EscReg	<= 1'b0;
				WEnPC		<= 1'b0;
			end
			ID: begin					/* Instruction Decode */
				EscIR		<= 1'b1;
				EscReg	<= 1'b0;
				WEnPC		<= 1'b0;
			end
			RF: begin					/* Register Fetch */
				EscIR		<= 1'b0;
				EscReg	<= 1'b0;
				WEnPC		<= 1'b0;
			end
			EX: begin					/* Execution */
				EscIR		<= 1'b0;
				EscReg	<= 1'b0;
				WEnPC		<= 1'b0;
			end
			WB: begin					/* WriteBack */
				EscIR		<= 1'b0;
				WEnPC		<= 1'b1;
				if (OpCode == InsJ || OpCode == InsBEZ || OpCode == InsMUL) begin
					EscReg	<= 1'b0;			// Instruçao de jump, desabilita escrita no banco
				end
				else begin
					EscReg	<= 1'b1;
				end
			end
			default: begin
				EscIR		<= 1'b0;
				EscReg	<= 1'b0;
				WEnPC		<= 1'b0;
			end
		endcase
	end
	
	/* Conversao de OpCode para operaçao ULA e sinais para os Mux */
	always @( * ) begin
		case (OpCode)
			InsADD: begin				/* Adiçao Reg-Reg */				
				ULA_OP		<= ULAADD;		
				ULA_B			<= 1'b0;			//MuxOpB: RegB
				EscCP			<= 1'b0;
				EscCondCP	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsSUB: begin				/* Subtraçao Reg-Reg */
				ULA_OP		<= ULASUB;
				ULA_B			<= 1'b0;			//MuxOpB: RegB
				EscCP			<= 1'b0;
				EscCondCP	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsSLTI: begin				/* Comparaçao Reg-Imm */
				ULA_OP		<= ULASLT;
				ULA_B			<= 1'b1;			//MuxOpB: Imm
				EscCP			<= 1'b0;
				EscCondCP	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsAND: begin				/* AND Reg-Reg */
				ULA_OP		<= ULAAND;
				ULA_B			<= 1'b0;			//MuxOpB: RegB
				EscCP			<= 1'b0;			
				EscCondCP	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsOR: begin				/* OR Reg-Reg */
				ULA_OP		<= ULAOR;
				ULA_B			<= 1'b0;			//MuxOpB: RegB
				EscCP			<= 1'b0;
				EscCondCP	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsXOR: begin				/* XOR Reg-Reg */
				ULA_OP		<= ULAXOR;
				ULA_B 		<= 1'b0;			//MuxOpB: RegB
				EscCP			<= 1'b0;
				EscCondCP 	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsANDI: begin				/* AND Reg-Imm */
				ULA_OP 		<= ULAAND;
				ULA_B 		<= 1'b1;			//MuxOpB: Imm
				EscCP			<= 1'b0;
				EscCondCP 	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsORI: begin				/* OR Reg-Imm */
				ULA_OP 		<= ULAOR;
				ULA_B 		<= 1'b1;			//MuxOpB: Imm
				EscCP			<= 1'b0;			
				EscCondCP 	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsXORI: begin				/* XOR Reg-Imm */
				ULA_OP 		<= ULAXOR;
				ULA_B 		<= 1'b1;			//MuxOpB: Imm
				EscCP			<= 1'b0;				
				EscCondCP 	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsADDI: begin				/* Adiçao Reg-Imm */
				ULA_OP 		<= ULAADD;
				ULA_B 		<= 1'b1;			//MuxOpB: Imm
				EscCP			<= 1'b0;				
				EscCondCP 	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsSUBI: begin				/* Subtraçao Reg-Imm */
				ULA_OP 		<= ULASUB;
				ULA_B 		<= 1'b1;			//MuxOpB: Imm
				EscCP			<= 1'b0;
				EscCondCP 	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsJ: begin					/* Jump */
				ULA_OP		<= 4'bxxxx;		//Don't care
				ULA_B 		<= 1'b0;			//MuxOpB: RegB (dont care)
				EscCP 		<= 1'b1;			//Jump Signal
				EscCondCP 	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsBEZ: begin				/* Branch if Equals Zero */
				ULA_OP		<= ULABEZ;
				ULA_B			<= 1'b0;			//MuxOpB: RegB
				EscCP 		<= 1'b0;			//Jump Signal
				EscCondCP 	<= 1'b1;			//Condicional Branch Signal
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
			InsMUL: begin				/* Multiplicacao Reg-Reg */
				ULA_OP		<= 4'bxxxx;		//ULA nao opera
				ULA_B			<= 1'b0;			//MuxOpB: RegB
				EscCP			<= 1'b0;
				EscCondCP	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b1;
				HILO_WB		<= 1'b0;
			end
			InsGHI: begin				/* Armazena registro HI */
				ULA_OP		<= 4'bxxxx;		//ULA nao opera
				ULA_B			<= 1'b0;			//MuxOpB: RegB
				EscCP			<= 1'b0;
				EscCondCP	<= 1'b0;
				HILO			<= 1'b1;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b1;
			end
			InsGLO: begin				/* Armazena registro LO */
				ULA_OP		<= 4'bxxxx;		//ULA nao opera
				ULA_B			<= 1'b0;			//MuxOpB: RegB
				EscCP			<= 1'b0;
				EscCondCP	<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b1;
			end
			default: begin				/* Operando Invalido */
				ULA_OP		<= 4'bxxxx;		//Dont care
				ULA_B			<= 1'b0;
				EscCondCP	<= 1'b0;
				EscCP			<= 1'b0;
				HILO			<= 1'b0;
				IsMulWB 		<= 1'b0;
				HILO_WB		<= 1'b0;
			end
		endcase
	end
endmodule
