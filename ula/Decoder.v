//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* Decodificar de instruçoes
		Recebe uma instruçao de 16-bit na forma
			INSTR	DST, IMM|REGB, REGA
		e decofica para instruçao da ALU e operandos
*/
module Decoder ( Instr, isImm, isValid, OpALU, OpA, OpB, OpC, CLK );
	
	input CLK;
	input [15:0] Instr;
	output [3:0] OpA, OpB, OpC;
	output reg isImm, isValid;
	output reg [3:0] OpALU;
	
	assign OpC = Instr[11:8];
	assign OpB = Instr[7:4];
	assign OpA = Instr[3:0];
	
	/* Codigo de Instruçoes da maquina */
	parameter InsADD  = 4'b0000;	// ADD	$s4, $s3, $s2
	parameter InsSUB  = 4'b0001;	//	SUB	$s4, $s3, $s2
	parameter InsSLTI = 4'b0010;	//	SLTI	$s4, imm, $s2
	parameter InsAND  = 4'b0011;	//	AND 	$s4, $s3, $s2
	parameter InsOR   = 4'b0100;	//	OR 	$s4, $s3, $s2
	parameter InsXOR  = 4'b0101;	//	XOR 	$s4, $s3, $s2
	parameter InsANDI = 4'b0110;	//	ANDI 	$s4, imm, $s2
	parameter InsORI  = 4'b0111;	//	ORI 	$s4, imm, $s2
	parameter InsXORI = 4'b1000;	//	XORI 	$s4, imm, $s2
	parameter InsADDI = 4'b1001;	//	ADDI 	$s4, imm, $s2
	parameter InsSUBI = 4'b1010;	//	SUBI 	$s4, imm, $s2
	
	/* Codigo de operaçoes da ALU */
	parameter ALUADD = 4'b0000;	// ADD
	parameter ALUSUB = 4'b0001;	//	SUB
	parameter ALUSLT = 4'b0010;	//	SLTI
	parameter ALUAND = 4'b0011;	//	AND
	parameter ALUOR =  4'b0100;	//	OR
	parameter ALUXOR = 4'b0101;	//	XOR
	
	always @( posedge CLK ) begin
		case (Instr[15:12])
			InsADD: begin
				isImm = 0;
				isValid = 1;
				OpALU = ALUADD;
			end
			InsSUB: begin
				isImm = 0;
				isValid = 1;
				OpALU = ALUSUB;
			end
			InsSLTI: begin
				isImm = 1;
				isValid = 1;
				OpALU = ALUSLT;
			end
			InsAND: begin
				isImm = 0;
				isValid = 1;
				OpALU = ALUAND;
			end
			InsOR: begin
				isImm = 0;
				isValid = 1;
				OpALU = ALUOR;
			end
			InsXOR: begin
				isImm = 0;
				isValid = 1;
				OpALU = ALUXOR;
			end
			InsANDI: begin
				isImm = 1;
				isValid = 1;
				OpALU = ALUAND;
			end
			InsORI: begin
				isImm = 1;
				isValid = 1;
				OpALU = ALUOR;
			end
			InsXORI: begin
				isImm = 1;
				isValid = 1;
				OpALU = ALUXOR;
			end
			InsADDI: begin
				isImm = 1;
				isValid = 1;
				OpALU = ALUADD;
			end
			InsSUBI: begin
				isImm = 1;
				isValid = 1;
				OpALU = ALUSUB;
			end
			default: begin
				isValid = 0;
				isImm = 0;
				OpALU = 4'b0000;
			end
		endcase
	end
endmodule
