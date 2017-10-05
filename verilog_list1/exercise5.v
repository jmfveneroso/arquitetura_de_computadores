// Solucao do exercicio 5. Contador de numeros primos.
`timescale 10ps / 1ps
module exercise5 (
  input wire clock,
  input wire reset,
  input wire direction,
  output reg[0:4] number
);

always @ (posedge clock)
  if (reset == 1) begin
    if (direction == 0) begin
      number = 2;
	 end else begin
	   number = 13;
	 end 
  end else begin
    if (direction == 0) begin
      case (number)
		  2:  number = 3;
		  3:  number = 5; 
		  5:  number = 7;
		  7:  number = 11;
		  11: number = 13;
      endcase
	 end else begin
	   case (number)
		  13: number = 11;
		  11: number = 7;
        7:  number = 5;   
		  5:  number = 3;
		  3:  number = 2;
		endcase
	 end 
  end
   
endmodule 

module exercise5tb ();

reg clock;
reg reset;
reg direction;
wire[0:4] number;
   
exercise5 e5 (
  .clock(clock),
  .reset(reset),
  .direction(direction),
  .number(number)
);

initial begin
  clock = 1;
  reset = 1;
  direction = 0;
  #5 reset = 0;
  #55 direction = 1; 
  reset = 1;
  #5 reset = 0;
  #100 $finish;
end

always
  #5 clock = ~clock;
	
endmodule 