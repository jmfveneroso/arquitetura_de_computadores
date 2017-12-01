//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/*			Modulo de controle para o estagio de decodificacao

	Decodificacao responsavel por buscar instrucao na memoria,
	atualizar buffer do pipeline Dec/Exe e atualizar registro PC
	
*/
module ControlDecode(	CLK,
								RST,
								DecExeBufferWr,
								PCRegWr,
								SetStallDec,
								ClrStallDec,
								IsDecStall
								);
	
	input CLK, RST;
	
	//-- Sinais Decode
	output reg	DecExeBufferWr;	// Sinal para escrever no buffer entre decodificacao e execucao
	output reg	PCRegWr;				// Sinal para escrever no registrador PC
	input 		SetStallDec;		// Sinal para colocar maquina de estados do decoder em stall
	input			ClrStallDec;		// Sinal para tirar maquina de estados do decoder do stall
	output reg	IsDecStall;			// Sinal que indica se a maquina de estados do decoder esta em stall
	
	//-- Registradores internos
	reg [1:0] DecodeState;			// Estado da maquina de decode
											// 0: Busca instrucao na memoria
											// 1: Decodifica e escreve no buffer DEC/EXE
											// 2: Stall
	
	parameter DEC0 = 2'b00, DEC1 = 2'b01, DEC2 = 2'b10;
	
	/* Maquina de estados para a Decodificacao */
	always @ (posedge CLK) begin
		if ( RST ) begin
			DecodeState <= DEC0;
		end
		else begin
			case (DecodeState)
				DEC0: begin
					DecodeState <= DEC1;
				end
				DEC1: begin
					if (SetStallDec)
						DecodeState <= DEC2;
					else
						DecodeState <= DEC0;
				end
				DEC2: begin
					if (ClrStallDec)
						DecodeState <= DEC0;
					else
						DecodeState <= DEC2;
				end
			endcase
		end
	end
	
	/* Sinais para mudancas nos estados de decode */
	always @ (*) begin
		case (DecodeState)
			DEC0: begin
				// Busca de instrucao na memoria
				DecExeBufferWr		<= 1'b0;
				PCRegWr				<= 1'b0;
				IsDecStall			<= 1'b0;
				
			end
			DEC1: begin
				// Decodificacao e armazenamento no buffer 
				DecExeBufferWr		<= 1'b1;
				PCRegWr				<= 1'b1;
				IsDecStall			<= 1'b0;
			
			end
			DEC2: begin
				// Stall
				DecExeBufferWr		<= 1'b0;
				PCRegWr				<= 1'b0;
				IsDecStall			<= 1'b1;
				
			end
		endcase
	end
	
endmodule
