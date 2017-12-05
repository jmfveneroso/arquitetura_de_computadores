//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* 	Decodificar de instruçoes
	Recebe uma instruçao de 16-bit na forma	INSTR	DST, IMM|REGB, REGA
	EN: Enable
*/
module Decoder ( Instr, OpCode, OpA, OpB, OpC, AddrImm, CLK, EN );
	
	input CLK, EN;
	input [15:0] Instr;
	output [3:0] OpCode, OpA, OpB, OpC;
	output [11:0] AddrImm;
	
	reg [15:0] InstrReg;				// Instruction Register
	
	assign OpCode	= InstrReg[15:12];
	assign OpC 		= InstrReg[11:8];
	assign OpB		= InstrReg[7:4];
	assign OpA		= InstrReg[3:0];
	assign AddrImm = InstrReg[11:0];
	
	always @( posedge CLK ) begin
		if (EN) begin
			InstrReg <= Instr;
		end
	end
endmodule
