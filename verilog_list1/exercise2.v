// Solucao do exercicio 2. Somador completo.
module exercise2 (
  input[1:0] a,
  input[1:0] b,
  input carry_in,
  output[1:0] out,
  output carry_out
);

assign {carry_out, out} = carry_in + b + a;
   
endmodule 