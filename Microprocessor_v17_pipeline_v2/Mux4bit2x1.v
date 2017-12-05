//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

// Mux de 4-bit 2 entradas
module Mux4bit2x1 (A, B, S, SEL);

	input SEL;
	input [3:0] A, B;
	output reg [3:0] S;

	always @(A or B or SEL)
	begin
		if (SEL == 0)
			S = A;
		else
			S = B;
	end

endmodule
