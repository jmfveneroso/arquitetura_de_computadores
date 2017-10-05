//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

// <ux de 16-bit 2 entradas
module Mux16bit2x1 (A, B, S, SEL);

	input SEL;
	input [15:0] A, B;
	output reg [15:0] S;

	always @(A or B or SEL)
	begin
		if (SEL == 0)
			S = A;
		else
			S = B;
	end

endmodule
