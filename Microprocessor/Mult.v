//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/*	Modulo de multiplicacao
	S = A * B
*/
module Mult(A, B, HI, LO, EN, CLK);

	input [15:0] A, B;
	input EN, CLK;
	output reg [15:0] HI, LO;
	
	wire [31:0] result;
	
	assign result = A * B;

	always @(posedge CLK) begin
		if (EN) begin
			HI <= result[31:16];
			LO <= result[15:0];
		end
	end
endmodule
