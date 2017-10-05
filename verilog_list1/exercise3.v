// Solucao do exercicio 3. Somador completo por meio de dois meio
// somadores.
module half_adder (
  input a,
  input b,
  output out_sum,
  output out_carry
);

assign out_sum = a ^ b;
assign out_carry = a & b;
   
endmodule

module exercise3 (
  input a,
  input b,
  input carry_in,
  output out_sum,
  output out_carry
);

wire sum_1;
wire carry_1;
wire carry_2;

half_adder half_adder_1 (
  .a(a), .b(b), .out_sum(sum_1), .out_carry(carry_1)
);

half_adder half_adder_2 (
  .a(sum_1), .b(carry_in), .out_sum(out_sum), .out_carry(carry_2)
);

assign carry_out = carry_1 | carry_2; 
   
endmodule 