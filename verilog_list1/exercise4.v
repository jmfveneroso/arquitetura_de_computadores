// Solucao do exercicio 4. O elevador possui um fio (fr) para
// cada andar, que fica ativo quando alguem chama o elevador. Alem
// disso, o elevador informa para a unidade de controle
// em qual andar ele esta por meio do fio (cur_floor). O fio
// door_opened indica se a porta esta aberta, para que o elevador
// nao se mova. Finalmente, a unidade de controle indica qual deve
// ser a proxima acao do elevador por meio do registro de saida (state).
`timescale 10ps / 1ps
module exercise4 (
  input wire[7:0] fr,        // Floor request.
  input wire[3:0] cur_floor, // Andar atual.
  input wire door_opened,    // Porta aberta.
  output reg[1:0] state
);

parameter WAIT = 3'b00, UP = 3'b10, DOWN = 3'b11;
		
reg[3:0] next_floor_u;
reg[3:0] next_floor_d;
reg[3:0] next_floor;
			 
always @ (*) begin
  // Nao ha nenhuma chamada. Permanece no andar atual.
  if (fr == 0 || door_opened) begin
    next_floor = cur_floor;
    state = WAIT;
  end else begin
    // Descobre o proximo andar para cima.
    case (cur_floor)
      0 : next_floor_u = fr[1]?1:fr[2]?2:fr[3]?3:fr[4]?4:fr[5]?5:fr[6]?6:fr[7]?7:0;
      1 : next_floor_u = fr[2]?2:fr[3]?3:fr[4]?4:fr[5]?5:fr[6]?6:fr[7]?7:1;
      2 : next_floor_u = fr[3]?3:fr[4]?4:fr[5]?5:fr[6]?6:fr[7]?7:2;
      3 : next_floor_u = fr[4]?4:fr[5]?5:fr[6]?6:fr[7]?7:3;
      4 : next_floor_u = fr[5]?5:fr[6]?6:fr[7]?7:4;
      5 : next_floor_u = fr[6]?6:fr[7]?7:5;
      6 : next_floor_u = fr[7]?7:6;
      7 : next_floor_u = 7;
    endcase

    // Descobre o proximo andar para baixo.
    case (cur_floor)
      0 : next_floor_d = 0;
      1 : next_floor_d = fr[0]?0:1;
      2 : next_floor_d = fr[1]?1:fr[0]?0:2;
      3 : next_floor_d = fr[2]?2:fr[1]?1:fr[0]?0:3;
      4 : next_floor_d = fr[3]?3:fr[2]?2:fr[1]?1:fr[0]?0:4;
      5 : next_floor_d = fr[4]?4:fr[3]?3:fr[2]?2:fr[1]?1:fr[0]?0:5;
      6 : next_floor_d = fr[5]?5:fr[4]?4:fr[3]?3:fr[2]?2:fr[1]?1:fr[0]?0:6;
      7 : next_floor_d = fr[6]?6:fr[5]?5:fr[4]?4:fr[3]?3:fr[2]?2:fr[1]?1:fr[0]?0:7;
    endcase

	 // Se houver alguma chamada, move o elevador naquela direcao.
    if (next_floor_u != cur_floor) begin
      next_floor = next_floor_u;
      state = UP;
    end else if (next_floor_d != cur_floor) begin
      next_floor = next_floor_d;
      state = DOWN;
    end
  end
end

endmodule 

module exercise4tb ();
  reg[7:0] fr;
  reg[3:0] cur_floor;
  reg door_opened;
  wire[1:0] state;
  
  exercise4 e4 (
    .fr(fr),
    .cur_floor(cur_floor),
    .door_opened(door_opened),
    .state(state)
  );

  initial begin
    $monitor(
      "Time = %g, fr = %d, cur_floor = %d, door_opened = %b, state = %b", 
      $time, fr, cur_floor, door_opened, state
    );

    fr = 0;
    cur_floor = 0;
    door_opened = 0;
    
    #5 fr = 2;
    #5 cur_floor = 1;
    #5 cur_floor = 2;
    door_opened = 1;
    #5 door_opened = 0;
    fr = 0;
    #5 fr = 1;
    #5 cur_floor = 1;
    #5 cur_floor = 0;
    door_opened = 1;
    #5 door_opened = 0;
    fr = 0;

    #100 $finish;
  end
endmodule 