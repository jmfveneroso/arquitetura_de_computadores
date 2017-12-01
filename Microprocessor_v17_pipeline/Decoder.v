//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* 	Decodificar de instruçoes
	Recebe uma instruçao de 16-bit na forma	INSTR	DST, IMM|REGB, REGA
*/
module Decoder ( Instr, OpCode, OpA, OpB, OpC, AddrImm, OpULA, IsImm, HasWB, HasStall, IsJump, IsMult, HiLo, StoreHiLo );
	
	input [15:0] Instr;
	output [3:0] OpCode, OpA, OpB, OpC;
	output [11:0] AddrImm;
	output reg [3:0] OpULA;
	output reg IsImm;					// Indica se instrucao e' imediata
	output reg IsJump;				// Indica se e instrucao de jump
	output reg HasWB;					// Indica se instrucai faz wb
	output reg HasStall;				// Indica que a instrucao gera stall
	output reg IsMult;				// Indica que instrucai vai usar o Multiplicador
	output reg HiLo;					// Indica qual registrador da mult vai armazenar
	output reg StoreHiLo;			// Indica que vai armazenar registrador de mult
	
	assign OpCode	= Instr[15:12];
	assign OpC 		= Instr[11:8];
	assign OpB		= Instr[7:4];
	assign OpA		= Instr[3:0];
	assign AddrImm = Instr[11:0];
	
	/* OpCode das instrucoes */
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
	parameter InsJ		= 4'b1011;	// J		imm
	parameter InsBEZ	= 4'b1100;	//	BEZ	, $s3, $s2
	parameter InsMUL	= 4'b1101;	// MUL	-, $s3, $s2
	parameter InsGHI	= 4'b1110;	// GHI	$s4, , 
	parameter InsGLO	= 4'b1111;	// GLO	$s4, , 
	
	/* Codigo de operaçoes da ALU */
	parameter ULAADD = 4'b0000;	// ADD
	parameter ULASUB = 4'b0001;	//	SUB
	parameter ULASLT = 4'b0010;	//	SLTI
	parameter ULAAND = 4'b0011;	//	AND
	parameter ULAOR =  4'b0100;	//	OR
	parameter ULAXOR = 4'b0101;	//	XOR
	parameter ULABEZ = 4'b0110;	// BEZ
	parameter ULANOP = 4'b0111;	// NOP
	
	/* Selecao de imediato ou nao para instrucao */
	always @ ( * ) begin
		case (OpCode)
			InsADD: begin
				IsImm			<= 1'b0;
				HasWB			<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA			<= ULAADD;
			end
			InsSUB: begin
				IsImm 		<= 1'b0;
				HasWB 		<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULASUB;
			end
			InsSLTI:	begin
				IsImm 		<= 1'b1;
				HasWB 		<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULASLT;
			end
			InsAND: begin
				IsImm 		<= 1'b0;
				HasWB 		<= 1'b1;	
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULAAND;
			end
			InsOR: begin
				IsImm 		<= 1'b0; 
				HasWB 		<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULAOR;
			end
			InsXOR: begin
				IsImm 		<= 1'b0;
				HasWB 		<= 1'b1;	
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULAXOR;
			end
			InsANDI: begin
				IsImm 		<= 1'b1;
				HasWB 		<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULAAND;
			end
			InsORI: begin
				IsImm 		<= 1'b1;
				HasWB 		<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULAOR;
			end
			InsXORI: begin
				IsImm 		<= 1'b1; 
				HasWB 		<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULAXOR;
			end
			InsADDI: begin
				IsImm 		<= 1'b1; 
				HasWB 		<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULAADD;
			end
			InsSUBI: begin
				IsImm 		<= 1'b1; 
				HasWB 		<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULASUB;
			end
			InsJ:	begin
				IsImm			<= 1'b0; 
				HasWB 		<= 1'b0;
				HasStall		<= 1'b1;
				IsJump		<= 1'b1;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULANOP;
			end
			InsBEZ: begin
				IsImm 		<= 1'b0; 
				HasWB 		<= 1'b0;
				HasStall		<= 1'b1;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULABEZ;
			end
			InsMUL: begin
				IsImm 		<= 1'b0; 
				HasWB 		<= 1'b0;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b1;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULANOP;
			end
			InsGHI: begin
				IsImm 		<= 1'b0;
				HasWB 		<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b1;
				HiLo			<= 1'b1;
				OpULA 		<= ULANOP;
			end
			InsGLO: begin
				IsImm 		<= 1'b0;
				HasWB 		<= 1'b1;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b1;
				HiLo			<= 1'b0;
				OpULA 		<= ULANOP;
			end
			default: begin
				IsImm 		<= 1'b0;
				HasWB 		<= 1'b0;
				HasStall		<= 1'b0;
				IsJump		<= 1'b0;
				IsMult		<= 1'b0;
				StoreHiLo	<= 1'b0;
				HiLo			<= 1'b0;
				OpULA 		<= ULANOP;
			end
		endcase
	end
	
endmodule
