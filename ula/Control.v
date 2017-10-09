//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* Controle da microprocessador */
module Control (CLK, RST, Start, Ready, Wen );
	
	input CLK, RST, Start;
	output reg Ready, Wen;
	
	reg [2:0] State;
	
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101;
	
	always @(posedge CLK) begin
		if ( RST ) begin
			State <= S0;		// Inicia em Halt
			Ready <= 1;
			Wen <= 0;
		end
		else begin
			case (State)
				S0:						// Halt, aguarda sinal de 'Start'
				begin
					Ready <= 1;
					Wen <= 0;
					if (Start) begin
						State <= S1;
					end
				end
				S1:						// Decodificaçao de instruçao
				begin
					Ready <= 0;
					Wen <= 0;
					State <= S2;
				end
				S2:						// Busca de valores nos registradores
				begin
					Ready <= 0;
					Wen <= 0;
					State <= S3;
				end
				S3: 						// Execuçao 
				begin
					Ready <= 0;
					Wen <= 0;
					State <= S4;
				end
				S4:						// Write Back 
				begin
					Ready <= 0;
					Wen <= 1;
					State <= S0;
				end
				default: begin
					State = S0;
				end
			endcase
		end
	end	
endmodule

module ControlTB ();
  reg CLK, RST, Start;
  wire Ready, Wen;

  Control Control1 (
    .CLK(CLK),     // Clock
    .RST(RST),     // Reset.
    .Start(Start),  
    .Ready(Ready),  
    .Wen(Wen)      // Write enable.
  );

  reg TestResult;
  reg ExpectedWen, ExpectedReady;
  task CheckControlOutput;
    begin
      if (Wen != ExpectedWen) begin
        $display ("Error at time %d", $time); 
        $display ("Expected Wen to have value %d, Got Value %d", ExpectedWen, Wen); 
        $display ("Test result: FAILED."); 
        TestResult = 0;
        $finish;
      end else if (Ready != ExpectedReady) begin
        $display ("Error at time %d", $time); 
        $display ("Expected Ready to have value %b, Got Value %b", ExpectedReady, Ready); 
        $display ("Test result: FAILED."); 
        TestResult = 0;
        $finish;
      end else begin
        TestResult = 1;
      end
    end
  endtask
    
  initial begin
    TestResult = 1;

    ExpectedReady = 1'bx;
    ExpectedWen = 1'bx;

    ExpectedReady <= #5 1;
    ExpectedWen   <= #5 0;

    ExpectedReady <= #25 0;
    ExpectedWen   <= #25 0;

    ExpectedReady <= #35 0;
    ExpectedWen   <= #35 0;

    ExpectedReady <= #45 0;
    ExpectedWen   <= #45 0;

    ExpectedReady <= #55 0;
    ExpectedWen   <= #55 1;

    ExpectedReady <= #65 1;
    ExpectedWen   <= #65 0;
  end

  initial begin
    // Descomente para ver o resultado do controlador.
    // $monitor(
    //   "Time = %g, CLK = %d, Ready = %d, Wen = %d",
    //   $time, CLK, Ready, Wen
    // );

    // Reseta o estado do controlador.
    CLK = 0;
    RST = 1;
    Start = 0;

    #15
    RST = 0;
    Start = 1;

    #25
    Start = 0;

    #25
    $display ("Test result: PASSED.");  
    $finish;
  end

  always begin
    #5 CLK = ~CLK;
    CheckControlOutput();
  end
endmodule
