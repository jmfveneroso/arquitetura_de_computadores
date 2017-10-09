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

module ULATB ();
  reg CLK, RST;
  reg[15:0] OpA, OpB;
  reg[3:0] Op;
  wire[2:0] FlagReg;
  wire[15:0] Res;

  ULA ULA1 (
    .OpA(OpA),         // Operando A.
    .OpB(OpB),         // Operando B.
    .Res(Res),         // Resultado.
    .Op(Op),           // Código do operador.
    .FlagReg(FlagReg), // Flags: overflow = 0, neg = 1, zero = 2.
    .CLK(CLK),         // Clock
    .RST(RST)          // Reset.
  );

  reg TestResult;
  reg[15:0] ExpectedValue;
  reg[2:0] ExpectedFlags;
  task CheckULAOutput;
    begin
      if (Res != ExpectedValue) begin
        $display ("Error at time %d", $time); 
        $display ("Expected result to have value %d, Got Value %d", ExpectedValue, Res); 
        $display ("Test result: FAILED."); 
        TestResult = 0;
        $finish;
      end else if (FlagReg != ExpectedFlags) begin
        $display ("Error at time %d", $time); 
        $display ("Expected register A to have value %b, Got Value %b", ExpectedFlags, FlagReg); 
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

    ExpectedValue = 16'dx;
    ExpectedFlags = 2'dx;

    ExpectedValue <= #5 16'dx;
    ExpectedFlags <= #5 2'd0;

    ExpectedValue <= #15 32767;
    ExpectedFlags <= #15 2'd0;

    ExpectedValue <= #25 32768;
    ExpectedFlags <= #25 3'b011; // Deveria ser 010.

    ExpectedValue <= #35 0;
    ExpectedFlags <= #35 3'b100;

    ExpectedValue <= #45 16'b1110000000000000; // deveria ser 16'b1010000000000000.
    ExpectedFlags <= #45 3'b010;

    ExpectedValue <= #55 1;
    ExpectedFlags <= #55 3'b000;

    ExpectedValue <= #65 16'b1111111111111111; // Deveria ser 16'b1000000000000001.
    ExpectedFlags <= #65 3'b010;

    ExpectedValue <= #75 16'd1;
    ExpectedFlags <= #75 3'b000;

    ExpectedValue <= #85 16'd0;
    ExpectedFlags <= #85 3'b100;

    ExpectedValue <= #95 16'b0011111111111111;
    ExpectedFlags <= #95 3'b000;

    ExpectedValue <= #105 16'b1111111111111111;
    ExpectedFlags <= #105 3'b010;

    ExpectedValue <= #115 16'b0111111111111111;
    ExpectedFlags <= #115 3'b000;
  end

  initial begin
    // Descomente para ver o resultado da ULA.
    // $monitor(
    //   "Time = %g, CLK = %d, Res = %d, Flags = %b",
    //   $time, CLK, Res, FlagReg
    // );

    // Reseta o valor das flags.
    CLK = 0;
    RST = 1;

    // Testa a adição (código 0).
    #10
    RST = 0;
    Op = 0;
    OpA = 16383;
    OpB = 16384;

    // Overflow.
    #10
    OpA = 16384;
    OpB = 16384;

    // Zero flag.
    #10
    OpA = 0;
    OpB = 0;

    // Adição de números negativos.
    #10
    OpA = 16'b0010000000000000;
    OpB = 16'b1100000000000000;

    // Testa a subtração (código 1).
    #10
    Op = 1;
    OpA = 16384;
    OpB = 16383;

    // Negative flag.
    #10
    OpA = 16383;
    OpB = 16384;
   
    // Testa o operador > (código 2).
    #10
    Op = 2;
    OpA = 16384;
    OpB = 0;

    #10
    OpA = 0;
    OpB = 16384;

    // Testa o operador AND (código 3).
    #10
    Op = 3;
    OpA = 16'b0111111111111111;
    OpB = 16'b0011111111111111;

    // Testa o operador OR (código 4).
    #10
    Op = 4;
    OpA = 16'b0000000011111111;
    OpB = 16'b1111111100000000;

    // Testa o operador XOR (código 5).
    #10
    Op = 5;
    OpA = 16'b0101010101010101;
    OpB = 16'b0010101010101010;

    #20
    $display ("Test result: PASSED."); 
    $finish;
  end

  always begin
    #5 CLK = ~CLK;
    CheckULAOutput();
  end
endmodule
