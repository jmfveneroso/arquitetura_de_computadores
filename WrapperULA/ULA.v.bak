//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* Codigos das instruçoes:
			ADD = 0000
			SUB = 0001
			SLT = 0010
			AND = 0011
			OR =  0100
			XOR = 0101
*/

// OpA, OpB: Operandos de entrada. 16-bit
// Res: Resultado da operaçao. 16-bit
// Op: Codigo da operaçao a ser executada
module ULA (OpA, OpB, Res, Op, CLK);

	input CLK;
	input [3:0] Op;
	input [15:0] OpA, OpB;
	output reg [15:0] Res;

	parameter InsADD = 4'b0000;	// ADD	Res = OpA + OpB
	parameter InsSUB = 4'b0001;	//	SUB	Res = OpA - OpB
	parameter InsSLT = 4'b0010;	//	SLTI	Res = (OpA > OpB) ? 1 : 0
	parameter InsAND = 4'b0011;	//	AND 	Res = OpA & OpB
	parameter InsOR =  4'b0100;	//	OR 	Res = OpA | OpB
	parameter InsXOR = 4'b0101;	//	XOR 	Res = OpA ^ OpB
	
	always @(posedge CLK) begin
		case (Op)
			InsADD: begin			
				Res = OpA + OpB;
			end
			InsSUB: begin			
				Res = OpA - OpB;
			end
			InsSLT: begin
				if (OpA > OpB)
					Res = 16'd1;
				else
					Res = 16'd0;
			end
			InsAND: begin			
				Res = OpA & OpB;
			end
			InsOR: begin			
				Res = OpA | OpB;
			end
			InsXOR: begin			
				Res = OpA ^ OpB;
			end
		endcase
	end
endmodule


