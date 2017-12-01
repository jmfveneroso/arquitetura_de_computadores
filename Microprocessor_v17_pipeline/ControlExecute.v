//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/*			Modulo de controle para o estagio de execucao

	Execucao responsavel por encaminhar registros para ula e mult
	e executar operacoes na ula e mult, testar branches
	
*/
module ControlExecute(	CLK,
								RST,
								ExeWBBufferWr);
	
	input CLK, RST;
								
								
	//-- Sinais Execute
	output reg ExeWBBufferWr;		// Sinal para escrever no buffer entre execucao e writeback

	reg [1:0] ExecutionState;		// Estado da maquina de execucao
											// 0: Busca de registros
											// 1: Execucao
											// 2: Stall

	parameter EXE0 = 2'b00, EXE1 = 2'b01, EXE2 = 2'b10;
	
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
	
	/* Sinais para mudancas nos estados de execucao */
	always @ (*) begin
		case (ExecutionState)
			EXE0: begin
				// Busca de registradores
				ExeWBBufferWr		<= 1'b0;
				
			end
			EXE1: begin
				// Execucao e armazenamento no buffer
				ExeWBBufferWr		<= 1'b1;
				
			end
			EXE2: begin
				// Stall
				ExeWBBufferWr		<= 1'b0;
				
			end
		endcase
	end

endmodule
