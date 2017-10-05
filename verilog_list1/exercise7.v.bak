// Solucao do exercicio 7. Banco de registradores de 16 bits.

`timescale 10ps / 1ps
module exercise7 (
  output reg[15:0] read_data_1, // Dados do primeiro registrador.
  output reg[15:0] read_data_2, // Dados do segundo registrador.
  input[15:0] write_data,       // Dados de escrita.
  input[3:0] read_register_1,   // Endereco do primeiro registrador.
  input[3:0] read_register_2,   // Endereco do segundo registrador.
  input[3:0] write_register,    // Endereco de escrita.
  input enable_write,	        // Habilita a escrita em posedge.
  input clk		                 // Clock.
);
  integer i;
  reg[15:0] registers[31:0];

  // Escrita.
  always @ (negedge clk) begin
    if (enable_write) begin
      for (i = 0; i < 32; i = i + 1) begin
        if (write_register == i) begin
          registers[i] = write_data;
        end
      end
    end
  end

  // Leitura.
  always @ (posedge clk) begin
    for (i = 0; i < 32; i = i + 1) begin
      if (read_register_1 == i) begin
        read_data_1 = registers[i];
      end 
      if (read_register_2 == i) begin
        read_data_2 = registers[i];
      end
    end
  end
endmodule

module exercise7tb ();
  wire[15:0] read_data_1;
  wire[15:0] read_data_2;
  reg [15:0] write_data;
  reg [3:0] read_register_1;
  reg [3:0] read_register_2;
  reg [3:0] write_register;
  reg enable_write;
  reg clk;

  exercise7 e7 (
    .read_data_1(read_data_1),
    .read_data_2(read_data_2),
    .write_data(write_data),
    .read_register_1(read_register_1),
    .read_register_2(read_register_2),
    .write_register(write_register),
    .enable_write(enable_write),
    .clk(clk)
  );

  initial begin
    write_data = 0;
    read_register_1 = 0;
    read_register_2 = 0;
    write_register = 0;
    enable_write = 0;
    clk = 0;

    #5 enable_write = 1;
    write_register = 7;
    write_data = 101;

    #10 enable_write = 1;
    write_register = 9;
    write_data = 534;

    #10 enable_write = 0;
    read_register_1 = 7;
    read_register_2= 9;

    #100 $finish;
  end

  always
    #5 clk = ~clk;

endmodule