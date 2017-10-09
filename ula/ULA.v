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
module ULA (OpA, OpB, Res, Op, FlagReg, CLK, RST);

	input CLK, RST;
	input [3:0] Op;
	input [15:0] OpA, OpB;
	output reg [15:0] Res;
	output reg [2:0] FlagReg;		// [Z N C]: Z=Zero; N=Neg; C=Carry/Overflow
	
	wire [15:0] invOpB;
	assign invOpB = ~OpB + 16'd1;

	parameter InsADD = 4'b0000;	// ADD	Res = OpA + OpB
	parameter InsSUB = 4'b0001;	//	SUB	Res = OpA - OpB
	parameter InsSLT = 4'b0010;	//	SLTI	Res = (OpA > OpB) ? 1 : 0
	parameter InsAND = 4'b0011;	//	AND 	Res = OpA & OpB
	parameter InsOR =  4'b0100;	//	OR 	Res = OpA | OpB
	parameter InsXOR = 4'b0101;	//	XOR 	Res = OpA ^ OpB
	
	parameter OverflowFlag	= 0;
	parameter NegFlag 		= 1;
	parameter ZeroFlag		= 2;
	
	always @(posedge CLK) begin
		if (RST) begin
				FlagReg = 3'b000;
		end
		else begin
			case (Op)
				InsADD: begin			
					Res = OpA + OpB;
					
					/* Zero check */
					if (Res == 0)
						FlagReg[ZeroFlag] = 1'b1;
					else
						FlagReg[ZeroFlag] = 1'b0;
					/* Overflow check */
					FlagReg[OverflowFlag] = (OpA[15] & OpB[15] & ~Res[15]) | (~OpA[15] & ~OpB[15] & Res[15]);
					/* Negative check */
					FlagReg[NegFlag] = Res[15];
				end
				InsSUB: begin			
					Res = OpA + invOpB;
					
					/* Zero check */
					if (Res == 0)
						FlagReg[ZeroFlag] = 1'b1;
					else
						FlagReg[ZeroFlag] = 1'b0;
					/* Overflow check */
					FlagReg[OverflowFlag] = (OpA[15] & invOpB[15] & ~Res[15]) | (~OpA[15] & ~invOpB[15] & Res[15]);
					/* Negative check */
					FlagReg[NegFlag] = Res[15];
				end
				InsSLT: begin
					if (OpA > OpB)
						Res = 16'd1;
					else
						Res = 16'd0;
						
					/* Zero check */
					if (Res == 0)
						FlagReg[ZeroFlag] = 1'b1;
					else
						FlagReg[ZeroFlag] = 1'b0;
					/* Overflow check */
					FlagReg[OverflowFlag] = (OpA[15] & OpB[15] & ~Res[15]) | (~OpA[15] & ~OpB[15] & Res[15]);
					/* Negative check */
					FlagReg[NegFlag] = Res[15];
				end
				InsAND: begin			
					Res = OpA & OpB;
					
					/* Zero check */
					if (Res == 0)
						FlagReg[ZeroFlag] = 1'b1;
					else
						FlagReg[ZeroFlag] = 1'b0;
					/* Overflow check */
					FlagReg[OverflowFlag] = (OpA[15] & OpB[15] & ~Res[15]) | (~OpA[15] & ~OpB[15] & Res[15]);
					/* Negative check */
					FlagReg[NegFlag] = Res[15];
				end
				InsOR: begin			
					Res = OpA | OpB;
					
					/* Zero check */
					if (Res == 0)
						FlagReg[ZeroFlag] = 1'b1;
					else
						FlagReg[ZeroFlag] = 1'b0;
					/* Overflow check */
					FlagReg[OverflowFlag] = (OpA[15] & OpB[15] & ~Res[15]) | (~OpA[15] & ~OpB[15] & Res[15]);
					/* Negative check */
					FlagReg[NegFlag] = Res[15];
				end
				InsXOR: begin			
					Res = OpA ^ OpB;
					
					/* Zero check */
					if (Res == 0)
						FlagReg[ZeroFlag] = 1'b1;
					else
						FlagReg[ZeroFlag] = 1'b0;
					/* Overflow check */
					FlagReg[OverflowFlag] = (OpA[15] & OpB[15] & ~Res[15]) | (~OpA[15] & ~OpB[15] & Res[15]);
					/* Negative check */
					FlagReg[NegFlag] = Res[15];
				end
			endcase
		end
	end
endmodule
