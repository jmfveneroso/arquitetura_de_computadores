//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

// Banco de registradores - 16 registradores de 16-bit
module RegisterBank ( AddrRegA, AddrRegB, AddrWriteReg, Data, WEN, CLK, RST, RegA, RegB );
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
		if ( RST )
			for ( i = 0; i < 16; i = i + 1) begin
				RegBank[i] <= 16'h0000;
			end
		else
			if ( WEN )
				RegBank[AddrWriteReg] <= Data;
			else begin
				RegA <= RegBank[AddrRegA];
				RegB <= RegBank[AddrRegB];
			end
	end
endmodule

module RegisterBankTB ();
  reg WEN, CLK, RST;
  reg[3:0] AddrRegA, AddrRegB, AddrWriteReg;
  reg[15:0] Data;
  wire[15:0] RegA, RegB;

  RegisterBank RegisterBank1 (
    .AddrRegA(AddrRegA), 
    .AddrRegB(AddrRegB),
    .AddrWriteReg(AddrWriteReg),
    .Data(Data), 
    .WEN(WEN), // Write enable.
    .CLK(CLK), // Clock.
    .RST(RST), // Reset.
    .RegA(RegA),
    .RegB(RegB)
  );

  reg TestResult;
  reg[15:0] ExpectedValueA, ExpectedValueB;
  task CheckRegisterBankOutput;
    begin
      if (RegA != ExpectedValueA) begin
        $display ("Error at time %d", $time); 
        $display ("Expected register A to have value %d, Got Value %d", ExpectedValueA, RegA); 
        $display ("Test result: FAILED."); 
        TestResult = 0;
        $finish;
      end else if (RegB != ExpectedValueB) begin
        $display ("Error at time %d", $time); 
        $display ("Expected register A to have value %d, Got Value %d", ExpectedValueB, RegB); 
        $display ("Test result: FAILED."); 
        TestResult = 0;
        $finish;
      end else begin
        TestResult = 1;
      end
    end
  endtask
    
  initial begin
    TestResult = 1;

    ExpectedValueA = 16'bxxxxxxxxxxxxxxxx;
    ExpectedValueB = 16'bxxxxxxxxxxxxxxxx;

    ExpectedValueA <= #55 1;
    ExpectedValueB <= #55 5;

    ExpectedValueA <= #65 11;
    ExpectedValueB <= #65 15;

    ExpectedValueA <= #75 0;
    ExpectedValueB <= #75 0;
  end

  initial begin
    // Descomente se quiser ver os valores dos registradores.
    // $monitor(
    //   "Time = %g, CLK = %d, RegA = %d, RegB = %d,
    //   $time, CLK, RegA, RegB
    // );

    // Reseta o valor dos 16 registradores.
    CLK = 0;
    RST = 1;

    // Escreve o valor 1 no registrador 0.
    #10
    RST = 0;
    WEN = 1;
    Data = 1;
    AddrWriteReg = 0;
   
    // Escreve o valor 5 no registrador 5.
    #10
    Data = 5;
    AddrWriteReg = 5;

    // Escreve o valor 11 no registrador 11.
    #10
    Data = 11;
    AddrWriteReg = 11;

    // Escreve o valor 15 no registrador 15.
    #10
    Data = 15;
    AddrWriteReg = 15;

    // Lê os registradores 0 e 5.
    #10
    WEN = 0;
    AddrRegA = 0;
    AddrRegB = 5;

    // Lê os registradores 11 e 15.
    #10
    AddrRegA = 11;
    AddrRegB = 15;

    // Lê os registradores 2 e 3.
    #10
    AddrRegA = 2;
    AddrRegB = 3;

    #20
    $display ("Test result: PASSED."); 
    $finish;
  end

  always begin
    #5 CLK = ~CLK;
    CheckRegisterBankOutput();
  end
endmodule
