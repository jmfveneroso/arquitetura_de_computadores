//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

// Banco de registradores - 16 registradores de 16-bit
module RegisterBank ( CLK, RST, AddrRegA, AddrRegB, AddrWriteReg, Data, WEN, RegA, RegB );

	input WEN, CLK, RST;			// Sinais de controle
	input [15:0] Data;			// Barramento de dados 16-bit
	input [3:0] AddrRegA;		// Endereço do registrador A para leitura
	input [3:0] AddrRegB;		// Endereço do registrador B para leitura
	input [3:0] AddrWriteReg;	// Endereço do registrador a ser escrito
	output reg [15:0] RegA;		// Valor do registrador A
	output reg [15:0] RegB;		// Valor do registrador B

	reg [15:0] RegBank[15:0];

	integer i;

	always @( posedge CLK ) begin
		if ( RST ) begin
			for ( i = 0; i < 16; i = i + 1) begin
				RegBank[i] <= 16'h0000;
			end
		end
		else begin
			if ( WEN ) begin
				RegBank[AddrWriteReg] <= Data;
			end
			// else begin				
			RegA <= RegBank[AddrRegA];
			RegB <= RegBank[AddrRegB];
			//end
		end
	end
	
endmodule
