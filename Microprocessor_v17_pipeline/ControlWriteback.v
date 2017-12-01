//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/*			Modulo de controle para o estagio de execucao

	Writeback responsavel por escrever o resultado da instrucao
	no banco de registradores
*/
module ControlWriteback(	CLK,
									RST,
									RegBankWr,
									ClrStall,
									HasJumped,
									HasStall,
									UpdateJmpPC);
	
	input CLK, RST;
	
	//-- Sinais Writeback
	output reg	RegBankWr;			// Sinal para escrever no banco de registradores
	output reg	ClrStall;			// Sinal para tirar decode do stall
	input			HasJumped;			// Sinal para indicar se houve ou nao o jump
	input			HasStall;			// Sinaliza que a maquina esta parada
	output reg	UpdateJmpPC;		// Sinal para atualizar o PC no jump
	
	reg [1:0] WriteBackState;		// Estado da maquina de writeback
											// 0: Escreve no banco
											// 1: idle
											// 2: Stall
	
	parameter WB0 = 2'b00, WB1 = 2'b01, WB2 = 2'b10;
	
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
	
	/* Sinais para mudancas nos estados de writeback */
	always @ (*) begin
		case (WriteBackState)
			WB0: begin
				// Grava no banco de registradores
				RegBankWr			<= 1'b1;
				ClrStall				<= 1'b0;
				UpdateJmpPC			<= 1'b0;
			end
			WB1: begin
				// Estado idle
				RegBankWr			<= 1'b0;
				if (HasStall) begin
					ClrStall				<= 1'b1;
				end
				else begin
					ClrStall				<= 1'b0;
				end
				if (HasJumped) begin
					UpdateJmpPC			<= 1'b1;
				end
				else begin
					UpdateJmpPC			<= 1'b0;
				end
			end
			WB2: begin
				// Stall
				RegBankWr			<= 1'b0;
				ClrStall				<= 1'b0;
				UpdateJmpPC			<= 1'b0;
			end
		endcase
	end
									
endmodule
