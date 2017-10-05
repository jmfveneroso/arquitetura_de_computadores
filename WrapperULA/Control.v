//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* Controle da microprocessador */
module Control (CLK, RST, Start, Ready, Wen, Go);
	
	input CLK, RST, Start, Go;
	output reg Ready, Wen;
	
	reg [2:0] State;
	
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;
	
	always @(posedge CLK) begin
		if ( RST ) begin
			State <= S0;		// Inicia em Halt
			Ready <= 1;
			Wen <= 0;
		end
		else begin
			case (State)
				S0:	// Halt, aguarda sinal de 'Start'
				begin
					Ready <= 1;
					Wen <= 0;
					if (Start) begin
						State <= S1;
					end
				end
				S1:	// Decodificaçao de instruçao
				begin
					Ready <= 0;
					Wen <= 0;		// Leitura no banco
					State <= S2;
				end
				S2:	// Busca de valores nos registradores
				begin
					Ready <= 0;
					Wen <= 0;		// Leitura no banco
					State <= S3;
				end
				S3: 	// Execuçao 
				begin
					Ready <= 0;
					Wen <= 0;		// Leitura no banco
					State <= S4;
				end
				S4: 	// Write Back 
				begin
					Ready <= 0;
					Wen <= 1;		// Escrita no banco
					State <= S5;
				end
				S5:					// Estado de sincronia, aguarda sinal de 'Go'
				begin
					Ready <= 0;
					Wen <= 0;		
					if (Go) begin
						State <= S0;
					end
				end
				default: begin
					State = S0;
				end
			endcase
		end
	end	
endmodule
