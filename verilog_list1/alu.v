// TP 2.

`timescale 10ps / 1ps
module regfile (
  output reg[15:0] read_data_1, // Register 1 data.
  output reg[15:0] read_data_2, // Register 2 data.
  input[15:0] write_data,       // Write data.
  input[3:0] read_register_1,   // Register 1 address.
  input[3:0] read_register_2,   // Register 2 address.
  input[3:0] write_register,    // Write address.
  input enable_write,	        // Enables write on negedge.
  input clk		        // Clock.
);
  integer i;
  reg[15:0] registers[15:0];

  // Writes on negative edge and reads on positive edge.
  always @ (negedge clk) begin
    if (enable_write) begin
      for (i = 0; i <= 15; i = i + 1) begin
        if (write_register == i) begin
          registers[i] = write_data;
        end
      end
    end
  end

  always @ (posedge clk) begin
    for (i = 0; i <= 15; i = i + 1) begin
      if (read_register_1 == i) begin
        read_data_1 = registers[i];
      end 
      if (read_register_2 == i) begin
        read_data_2 = registers[i];
      end
    end
  end

  initial begin
    registers[3] = 5;
    registers[7] = 1;
    $monitor(
      "reg0 = %b, reg1 = %b", 
      registers[0], registers[1]
    );
  end
endmodule

module alu (
  input[15:0] instruction, // [15:12] opcode, [11:8] write address, [7:4] read address 1, [3:0] read address 2.
  input[15:0] a,           // Register 1 data.
  input[15:0] b,           // Register 2 data.
  output reg[15:0] out     // Operation result.
);
  always@(instruction, a, b) begin
    begin
      case(instruction[15:12])
        0:  out = a + b;
        1:  out = a - b;
        2:  out = (b > instruction[7:4]) ? 1 : 0;
	3:  out = a & b;
	4:  out = a | b;
	5:  out = a ^ b;
	6:  out = a & instruction[7:4];
	7:  out = a | instruction[7:4];
	8:  out = a ^ instruction[7:4];
	9:  out = a + instruction[7:4];
	10: out = a - instruction[7:4];
      endcase
    end
  end
endmodule

module alutb ();
  reg[15:0] instruction;
  wire[15:0] read_data_1;
  wire[15:0] read_data_2;
  wire[15:0] write_data;
  wire[15:0] d_write;
  reg enable_write;
  reg clk;
  
  regfile register_file (
    .read_data_1(read_data_1), 
    .read_data_2(read_data_2),
    .write_data(write_data),
    .write_register(instruction[11:8]),
    .read_register_1(instruction[7:4]),
    .read_register_2(instruction[3:0]), 
    .enable_write(enable_write),
    .clk(clk)
  );
  
  alu alu1 (
    .instruction(instruction),
    .a(read_data_1), 
    .b(read_data_2),
    .out(write_data)
  );
  
  initial begin
    $monitor(
      "Time = %g, clk = %d, inst = %b, enable_w = %b, w_data = %b, r_1 = %b, r_2 = %b", 
      $time, clk, instruction, enable_write, write_data, read_data_1, read_data_2
    );

    instruction = 0;
    clk = 0;
    enable_write = 0;
    instruction[15:12] = 0;
    instruction[11:8] = 3;
    instruction[7:4] = 7;
    instruction[3:0] = 3;
    
    #5 
    enable_write = 1;

    #100 $finish;
  end

  always
    #5 clk = ~clk;

endmodule
