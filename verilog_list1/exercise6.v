// Solucao do exercicio 6. Caixa eletronico. Eu fiz uma pequena alteracao
// na definicao do exercicio: ao inves de RQ (retirar a quantia) ser
// uma saida da maquina, ela se tornou uma entrada que se torna positiva
// quando o cliente retira o dinheiro. Eu fiz isso porque faz mais sentido
// a maquina liberar o dinheiro (LV) e esperar ate que o cliente retire 
// a quantia (RQ) para prosseguir com o proximo passo. Alem disso, adicionei
// alguns estados internos (IC2, DS2, DQ2) referentes ao processamento das
// acoes do cliente, sendo que a nossa unidade de controle recebe como
// entradas os resultados desses processamentos (cv, sv, ss). Por fim, 
// eu omiti a acao (OF), pois ela sempre aparece entre a retirada do
// cartao (RC) e o estado idle da maquina (IC) e nao cumpre nenhum papel
// particular. Poderia haver um timer que mostra a tela de operacao finalizada
// por alguns segundos antes de mostrar a tela IC.
`timescale 10ps / 1ps
module exercise6 (
  input wire c,
  input wire cp,
  input wire cv,
  input wire sf,
  input wire sv,
  input wire qd,
  input wire ss,
  input wire rq,
  output reg[2:0] state
);

parameter IC = 3'b000, IC2 = 3'b001, DS = 3'b010, DS2 = 3'b011,
          DQ = 3'b100, DQ2 = 3'b101, LV = 3'b110, RC = 3'b111;
			 
always @ (*) begin
  case(state)
    // Inserir cartao.
    IC  : if (c == 1) begin
            state = RC;
          end else if (cp == 1) begin
            state = IC2;
          end
	 // Checar se cartao e valido.
	 IC2 : if (cv == 1) begin
            state = DS;
          end else begin
            state = RC;
          end
	 // Digitar senha.
	 DS  : if (c == 1) begin
            state = RC;
          end else if (sf == 1) begin
            state = DS2;
          end
	 // Checar se a senha e valida.
	 DS2 : if (sv == 1) begin
            state = DQ;
          end else begin
            state = RC;
          end
	 // Digitar quantia.
	 DQ  : if (c == 1) begin
            state = RC;
          end else if (qd == 1) begin
            state = DQ2;
          end
	 // Checar se usuario tem saldo suficiente.
	 DQ2 : if (ss == 1) begin
            state = LV;
          end else begin
            state = RC;
          end
	 // Liberar o valor solicitado.
	 LV  : if (rq == 1) begin
            state = RC;
          end
	 // Retirar cartao.
	 RC  : if (cp == 0) begin
            state = IC;
          end
	 default : state = IC;
  endcase
end

endmodule 

module exercise6tb ();

reg c;
reg cp;
reg cv;
reg sf;
reg sv;
reg qd;
reg ss;
reg rq;
wire[2:0] state;
  
exercise6 e6 (
  .c(c),
  .cp(cp),
  .cv(cv),
  .sf(sf),
  .sv(sv),
  .qd(qd),
  .ss(ss),
  .rq(rq),
  .state(state)
);

initial begin
  c = 0;
  cp = 0;
  cv = 0;
  sf = 0;
  sv = 0;
  qd = 0;
  ss = 0;
  rq = 0;
  
  #5 cp = 1;
  #5 cv = 1;
  #5 sf = 1;
  #5 sv = 1;
  #5 qd = 1;
  #5 ss = 1;
  #5 rq = 1;
  #5 cp = 0;
  
  #10 $finish;
end

endmodule 