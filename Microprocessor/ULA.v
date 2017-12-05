//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/*					Versao v0.1
	CHANGELOG {
		v0.1		Removido CLK e RST, totalmente combinacional agora
	}

*/

/* Codigos das instruçoes:
			ADD = 0000
			SUB = 0001
			SLT = 0010
			AND = 0011
			OR  = 0100
			XOR = 0101
			BEZ = 0110
	
	OpA, OpB: (16-bit) Operandos de entrada.
	Res:		 (16-bit) Resultado da operaçao.
	CodeULA:	 (4-bit)	 Codigo da operaçao a ser executada
*/
module ULA (OpA, OpB, Res, CodeULA, FlagReg);

	input [3:0] CodeULA;
	input [15:0] OpA, OpB;
	output reg [15:0] Res;
	output reg [2:0] FlagReg;		// [Z N V]: Z=Zero; N=Neg; V=Overflow
	
	wire [15:0] invOpB;
	assign invOpB = ~OpB + 16'd1;

	parameter InsADD = 4'b0000;	// ADD	Res = OpA + OpB
	parameter InsSUB = 4'b0001;	//	SUB	Res = OpA - OpB
	parameter InsSLT = 4'b0010;	//	SLTI	Res = (OpA > OpB) ? 1 : 0
	parameter InsAND = 4'b0011;	//	AND 	Res = OpA & OpB
	parameter InsOR =  4'b0100;	//	OR 	Res = OpA | OpB
	parameter InsXOR = 4'b0101;	//	XOR 	Res = OpA ^ OpB
	parameter InsBEZ = 4'b0110;	// BEZ	OpA == 0 ? Z = 1 : Z = 0; Res = OpB
	
	parameter OverflowFlag	= 0;
	parameter NegFlag 		= 1;
	parameter ZeroFlag		= 2;
	
	always @( * ) begin
		case (CodeULA)
			InsADD: begin			
				Res <= OpA + OpB;
				
				/* Zero check */
				if (Res == 0)
					FlagReg[ZeroFlag] <= 1'b1;
				else
					FlagReg[ZeroFlag] <= 1'b0;
				/* Overflow check */
				FlagReg[OverflowFlag] <= (OpA[15] & OpB[15] & ~Res[15]) | (~OpA[15] & ~OpB[15] & Res[15]);
				/* Negative check */
				FlagReg[NegFlag] <= Res[15];
			end
			InsSUB: begin			
				Res <= OpA + invOpB;
				
				/* Zero check */
				if (Res == 0)
					FlagReg[ZeroFlag] <= 1'b1;
				else
					FlagReg[ZeroFlag] <= 1'b0;
				/* Overflow check */
				FlagReg[OverflowFlag] <= (OpA[15] & invOpB[15] & ~Res[15]) | (~OpA[15] & ~invOpB[15] & Res[15]);
				/* Negative check */
				FlagReg[NegFlag] <= Res[15];
			end
			InsSLT: begin
				if (OpA > OpB)
					Res <= 16'd1;
				else
					Res <= 16'd0;
					
				/* Zero check */
				if (Res == 0)
					FlagReg[ZeroFlag] <= 1'b1;
				else
					FlagReg[ZeroFlag] <= 1'b0;
				/* Overflow check */
				FlagReg[OverflowFlag] <= (OpA[15] & OpB[15] & ~Res[15]) | (~OpA[15] & ~OpB[15] & Res[15]);
				/* Negative check */
				FlagReg[NegFlag] <= Res[15];
			end
			InsAND: begin			
				Res <= OpA & OpB;
				
				/* Zero check */
				if (Res == 0)
					FlagReg[ZeroFlag] <= 1'b1;
				else
					FlagReg[ZeroFlag] <= 1'b0;
				/* Overflow check */
				FlagReg[OverflowFlag] <= (OpA[15] & OpB[15] & ~Res[15]) | (~OpA[15] & ~OpB[15] & Res[15]);
				/* Negative check */
				FlagReg[NegFlag] <= Res[15];
			end
			InsOR: begin			
				Res <= OpA | OpB;
				
				/* Zero check */
				if (Res == 0)
					FlagReg[ZeroFlag] <= 1'b1;
				else
					FlagReg[ZeroFlag] <= 1'b0;
				/* Overflow check */
				FlagReg[OverflowFlag] <= (OpA[15] & OpB[15] & ~Res[15]) | (~OpA[15] & ~OpB[15] & Res[15]);
				/* Negative check */
				FlagReg[NegFlag] <= Res[15];
			end
			InsXOR: begin			
				Res <= OpA ^ OpB;
				
				/* Zero check */
				if (Res == 0)
					FlagReg[ZeroFlag] <= 1'b1;
				else
					FlagReg[ZeroFlag] <= 1'b0;
				/* Overflow check */
				FlagReg[OverflowFlag] <= (OpA[15] & OpB[15] & ~Res[15]) | (~OpA[15] & ~OpB[15] & Res[15]);
				/* Negative check */
				FlagReg[NegFlag] <= Res[15];
			end
			InsBEZ: begin
				Res <= OpB;
				
				/* Zero check */
				if (OpA == 0)
					FlagReg[ZeroFlag] <= 1'b1;
				else
					FlagReg[ZeroFlag] <= 1'b0;
				/* Overflow check */
				FlagReg[OverflowFlag] <= 1'bx;	// Don't care for Overflow
				/* Negative check */
				FlagReg[NegFlag] <= 1'bx;			// Don't care for Negative
			end
			default: begin
				Res <= 16'h0000;
				FlagReg[ZeroFlag] <= 1'b0;
				FlagReg[OverflowFlag] <= 1'b0;
				FlagReg[NegFlag] <= 1'b0;
			end
		endcase
	end
endmodule

