//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* Decodificador Display 7-Segmentos */
module Dec7Seg( Val, A, B, C, D, E, F, G, IDLE );

	input [3:0] Val;
	input IDLE;
	output reg A, B, C, D, E, F, G;

	always @(Val) begin
		if (IDLE) begin
			A = 1;
			B = 1;
			C = 1;
			D = 1;
			E = 1;
			F = 1;
			G = 0;
		end
		else begin
			case (Val)
				4'h0: begin
					A = 0;
					B = 0;
					C = 0;
					D = 0;
					E = 0;
					F = 0;
					G = 1;
				end
				4'h1: begin
					A = 1;
					B = 0;
					C = 0;
					D = 1;
					E = 1;
					F = 1;
					G = 1;
				end
				4'h2: begin
					A = 0;
					B = 0;
					C = 1;
					D = 0;
					E = 0;
					F = 1;
					G = 0;
				end
				4'h3: begin
					A = 0;
					B = 0;
					C = 0;
					D = 0;
					E = 1;
					F = 1;
					G = 0;
				end
				4'h4: begin
					A = 1;
					B = 0;
					C = 0;
					D = 1;
					E = 1;
					F = 0;
					G = 0;
				end
				4'h5: begin
					A = 0;
					B = 1;
					C = 0;
					D = 0;
					E = 1;
					F = 0;
					G = 0;
				end
				4'h6: begin
					A = 1;
					B = 1;
					C = 0;
					D = 0;
					E = 0;
					F = 0;
					G = 0;
				end
				4'h7: begin
					A = 0;
					B = 0;
					C = 0;
					D = 1;
					E = 1;
					F = 1;
					G = 1;
				end
				4'h8: begin
					A = 0;
					B = 0;
					C = 0;
					D = 0;
					E = 0;
					F = 0;
					G = 0;
				end
				4'h9: begin
					A = 0;
					B = 0;
					C = 0;
					D = 1;
					E = 1;
					F = 0;
					G = 0;
				end
				4'hA: begin
					A = 0;
					B = 0;
					C = 0;
					D = 1;
					E = 0;
					F = 0;
					G = 0;
				end
				4'hB: begin
					A = 1;
					B = 1;
					C = 0;
					D = 0;
					E = 0;
					F = 0;
					G = 0;
				end
				4'hC: begin
					A = 0;
					B = 1;
					C = 1;
					D = 0;
					E = 0;
					F = 0;
					G = 1;
				end
				4'hD: begin
					A = 1;
					B = 0;
					C = 0;
					D = 0;
					E = 0;
					F = 1;
					G = 0;
				end
				4'hE: begin
					A = 0;
					B = 1;
					C = 1;
					D = 0;
					E = 0;
					F = 0;
					G = 0;
				end
				4'hF: begin
					A = 0;
					B = 1;
					C = 1;
					D = 1;
					E = 0;
					F = 0;
					G = 0;
				end
			endcase
		end
	end
endmodule
