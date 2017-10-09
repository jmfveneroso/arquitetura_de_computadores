


/* Wrapper para simulaçao do ULA */

module WrapperSim(Instr, CLK, RST, RDY, START);

input [15:0] Instr;
input CLK, RST, START;
output RDY;

wire isImm, isValid, wen;
wire [3:0] opALU, opA, opB, opC;
wire [15:0] regA, regB, res, outMux;
wire [2:0] flagReg;

/* Decoder: Decoder ( Instr[15:0], isImm, isValid, OpALU[3:0]}, Op[3:0], OpB[3:0], OpC[3:0], CLK ) */
Decoder instdecode(Instr, isImm, isValid, opALU, opA, opB, opC, CLK);

/* RegisterBank: RegisterBank ( AddrRegA[3:0], AddrRegB[3:0], AddrWriteReg[3:0], Data[15:0], WEN, CLK, RST, RegA[15:0]], RegB[15:0] ) */
RegisterBank regBank(opA, opB, opC, res, wen, CLK, RST, regA, regB);

/* ULA: ULA (OpA, OpB, Res, Op, FlagReg, CLK, RST) */
ULA modULA(regA, outMux, res, opALU, flagReg, CLK, RST);

/* MUX: Mux16bit2x1 (A, B, S, SEL) */
Mux16bit2x1 muxOpImm(regB, { 12'h000, opB }, outMux, isImm);

/* Control: Control (CLK, RST, Start, Ready, Wen, Go) */
Control ctrl(CLK, RST, START, RDY, wen);

endmodule

module WrapperSimTB ();
  reg[15:0] Instr;
  reg CLK, RST, START;
  wire RDY;

  WrapperSim WrapperSim1 (
    .Instr(Instr),
    .CLK(CLK), 
    .RST(RST), 
    .RDY(RDY), 
    .START(START)
  );

  // Esse teste faz a operação (A XOR B) OR (C AND D) com os valores:
  // A (register ) = 0000000011011111.
  // B (register ) = 0000000011101111.
  // C (register ) = 0000111111111111.
  // D (immediate) = 0000000000001111.
  // A XOR B = 0000000000110000.
  // C AND D = 0000000000001111.
  // (A XOR B) OR (C AND D) = 0000000000111111.
  initial begin
    // Descomente para ver o banco de registradores.
    // $monitor(
    //   "Time = %g, CLK = %d, Instr = %b, Reg[0] = %b, Reg[1] = %b, Reg[2] = %b, Ready = %b",
    //   $time, CLK, Instr,
    //   WrapperSim1.regBank.RegBank[0],
    //   WrapperSim1.regBank.RegBank[1],
    //   WrapperSim1.regBank.RegBank[2],
    //   RDY
    // );

    CLK = 0;
    RST = 1;

    // Inicia os registradores. 
    #10
    RST = 0;
    WrapperSim1.regBank.RegBank[0] = 16'b0000000011011111;
    WrapperSim1.regBank.RegBank[1] = 16'b0000000011101111;
    WrapperSim1.regBank.RegBank[2] = 16'b0000111111111111;

    // XOR(5) 0 0 1
    #5
    START = 1;
    Instr = 16'b0101000000000001;

    // ANDI(6) 1 15 2
    #55
    Instr = 16'b0110000111110010;

    // OR(4) 0 0 1 
    #55
    Instr = 16'b0100000000000001;

    #55
    if (WrapperSim1.regBank.RegBank[0] != 16'b0000000000111111) begin
      $display ("Error at time %d", $time); 
      $display ("Expected result to have value %b, Got Value %b", 16'b0000000000111111, WrapperSim1.regBank.RegBank[0]); 
      $display ("Test result: FAILED."); 
      $finish;
    end else begin
      $display ("Test result: PASSED."); 
      $finish;
    end
  end

  always begin
    #5 CLK = ~CLK;
  end
endmodule
