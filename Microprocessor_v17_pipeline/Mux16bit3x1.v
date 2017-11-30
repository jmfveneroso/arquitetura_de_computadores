//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

// Mux de 16-bit 3 entradas
module Mux16bit3x1 (A, B, C, S, SEL);

	input [1:0] SEL;
	input [15:0] A, B, C;
	output reg [15:0] S;

	always @( * )
	begin
		case (SEL)
			2'b00: S <= A;
			2'b01: S <= B;
			2'b10: S <= C;
			default: S <= 16'b0;
		endcase
	end
endmodule
