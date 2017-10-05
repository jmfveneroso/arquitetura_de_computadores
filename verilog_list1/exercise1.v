// Solucao do exercicio 1, letra a.
module exercise1a (
  input wire a,
  input wire b,
  output wire z
);

assign z = a || !b;
   
endmodule 

// Solucao do exercicio 1, letra b.
module exercise1b (
  input wire a,
  input wire b,
  input wire c,
  output wire z
);

assign z = !(a && b) || c;
   
endmodule 

// Solucao do exercicio 1, letra c.
module exercise1c (
  input wire a,
  input wire b,
  input wire c,
  output wire z,
  output wire w
);

assign z = (a && b) || (c && b) || (c && a);
assign w = (!a && b) || (a && !b);
   
endmodule

// Solucao do exercicio 1, letra d.
module exercise1d (
  input wire a,
  input wire b,
  input wire c,
  input wire d,
  output wire z,
  output wire w
);

assign z = !(a || !c) && (b || d);
assign w = !z;
   
endmodule