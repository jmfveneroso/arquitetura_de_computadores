//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/*
		Modulo para o teste da ULA com o Banco de Registradores
*/

/* Instruçao generica:	INS OPC, OPA, OPB		(16-bit)
								OPC = OPA (op) OPB
			- 4-bit:	CODOp (Operaçao a ser feita)
			- 4-bit: OPA 	(Endereço do RegA)
			- 4-bit: OPB 	(Endereço do RegB ou Imediato)
			- 4-bit: OPC 	(Endereço do registrador de destino)
*/

/* OpB pode ser tanto o endereço do registrador B como o imediato
	
*/
module Microprocessor (Instr, CLK, RST, RDY, START);
	
	input CLK, RST, START;
	input [15:0] Instr;
	output reg RDY;
	
	wire [15:0] res, regA, regB, outMux;
	wire isImm;
	wire [3:0] opA, opB, opC, opALU;
	
	reg [2:0] state;
	reg wen;
	
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100;
	
	Decoder instdecode(Instr, isImm, opALU, opA, opB, opC, CLK);
	Mux16bit2x1 muxOpImm(regB, { 12'h000, opB }, outMux, isImm);
	RegisterBank regBank(opA, opB, opC, res, wen, CLK, RST, regA, regB);
	ULA modULA(regA, outMux, res, opALU, CLK);
	
	always @(posedge CLK) begin
		if ( RST ) begin
			state = S0;		// Inicia em Halt
			RDY = 1;
			wen = 0;
		end
		else begin
			case (state)
				S0:	// Halt
				begin
					RDY = 1;
					wen = 0;
					if (START) begin
						state = S1;
					end
				end
				S1:	// Decodificaçao de instruçao
				begin
					RDY = 0;	// 
					wen = 0;		// Leitura no banco
					state = S2;
				end
				S2:	// Busca de valores nos registradores
				begin
					RDY = 0;
					wen = 0;		// Leitura no banco
					state = S3;
				end
				S3: 	// Execuçao 
				begin
					RDY = 0;
					wen = 0;		// Leitura no banco
					state = S4;
				end
				S4: 	// Write Back 
				begin
					RDY = 0;
					wen = 1;		// Escrita no banco
					state = S0;
				end
				default: begin
					state = S0;
				end
			endcase
		end
	end	
endmodule
