//							Iuri Silva Castro
//			Mestrando em Engenharia Eletrica - PPGEE
//			Universidade Federal de Minas Gerais - UFMG
//									2º/2017

/* Wrapper do micro para DE2 */
module WrapperDE2(SW15, SW14, SW13, SW12,
						SW11, SW10, SW9, SW8,
						SW7, SW6, SW5, SW4,
						SW3, SW2, SW1, SW0,
						Hex0D0, Hex0D1, Hex0D2, Hex0D3, Hex0D4, Hex0D5, Hex0D6,		// HEX0
						Hex1D0, Hex1D1, Hex1D2, Hex1D3, Hex1D4, Hex1D5, Hex1D6,		// HEX1
						Hex2D0, Hex2D1, Hex2D2, Hex2D3, Hex2D4, Hex2D5, Hex2D6,		// HEX2
						Hex3D0, Hex3D1, Hex3D2, Hex3D3, Hex3D4, Hex3D5, Hex3D6,		// HEX3
						Hex4D0, Hex4D1, Hex4D2, Hex4D3, Hex4D4, Hex4D5, Hex4D6,		// HEX4
						Hex5D0, Hex5D1, Hex5D2, Hex5D3, Hex5D4, Hex5D5, Hex5D6,		// HEX5
						Hex6D0, Hex6D1, Hex6D2, Hex6D3, Hex6D4, Hex6D5, Hex6D6,		// HEX6
						Hex7D0, Hex7D1, Hex7D2, Hex7D3, Hex7D4, Hex7D5, Hex7D6,		// HEX7
						KEY0,
						KEY3,
						CLK, RST,
						GO			//SW17
						);

	// Definiçoes dos pinos de in/out
	input KEY0, KEY3;
	input SW15, SW14, SW13, SW12, SW11, SW10, SW9, SW8, SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0;
	output Hex0D0, Hex0D1, Hex0D2, Hex0D3, Hex0D4, Hex0D5, Hex0D6; 	// HEX0
	output Hex1D0, Hex1D1, Hex1D2, Hex1D3, Hex1D4, Hex1D5, Hex1D6;		// HEX1
	output Hex2D0, Hex2D1, Hex2D2, Hex2D3, Hex2D4, Hex2D5, Hex2D6;		// HEX2
	output Hex3D0, Hex3D1, Hex3D2, Hex3D3, Hex3D4, Hex3D5, Hex3D6;		// HEX3
	output Hex4D0, Hex4D1, Hex4D2, Hex4D3, Hex4D4, Hex4D5, Hex4D6;		// HEX4
	output Hex5D0, Hex5D1, Hex5D2, Hex5D3, Hex5D4, Hex5D5, Hex5D6;		// HEX5
	output Hex6D0, Hex6D1, Hex6D2, Hex6D3, Hex6D4, Hex6D5, Hex6D6;		// HEX6
	output Hex7D0, Hex7D1, Hex7D2, Hex7D3, Hex7D4, Hex7D5, Hex7D6;		// HEX7
	input CLK, RST;
	input GO; //SW17, usado como "debounce"

	wire isImm, isValid, wen, ready, rst;
	wire [3:0] opALU, opA, opB, opC, wRegA, wRegB, instrOpA, instrOpB;
	wire [15:0] regA, regB, res, outMux;
	wire [2:0] flagReg;
	wire [15:0] Instr;
	
	reg [15:0] resultado;
	reg start, idle_op, idle_view, isView;
	
	assign Instr = { SW15, SW14, SW13, SW12, SW11, SW10, SW9, SW8, SW7, SW6, SW5, SW4, SW3, SW2, SW1, SW0 };
	assign wRegA = { SW11, SW10, SW9, SW8 };
	assign wRegB = { SW7, SW6, SW5, SW4 };
	assign rst = ~RST;								// Inverte sinal de reset pois na DE2 o sinal e´ Normal HIGH
	
	// Instancias de modulos interface
	Dec7Seg hex0( resultado[3:0], Hex0D0, Hex0D1, Hex0D2, Hex0D3, Hex0D4, Hex0D5, Hex0D6, idle_op );
	Dec7Seg hex1( resultado[7:4], Hex1D0, Hex1D1, Hex1D2, Hex1D3, Hex1D4, Hex1D5, Hex1D6, idle_op );
	Dec7Seg hex2( resultado[11:8], Hex2D0, Hex2D1, Hex2D2, Hex2D3, Hex2D4, Hex2D5, Hex2D6, idle_op );
	Dec7Seg hex3( resultado[15:12], Hex3D0, Hex3D1, Hex3D2, Hex3D3, Hex3D4, Hex3D5, Hex3D6, idle_op );
	Dec7Seg hex4( regB[3:0], Hex4D0, Hex4D1, Hex4D2, Hex4D3, Hex4D4, Hex4D5, Hex4D6, idle_view );
	Dec7Seg hex5( regB[7:4], Hex5D0, Hex5D1, Hex5D2, Hex5D3, Hex5D4, Hex5D5, Hex5D6, idle_view );
	Dec7Seg hex6( regA[3:0], Hex6D0, Hex6D1, Hex6D2, Hex6D3, Hex6D4, Hex6D5, Hex6D6, idle_view );
	Dec7Seg hex7( regA[7:4], Hex7D0, Hex7D1, Hex7D2, Hex7D3, Hex7D4, Hex7D5, Hex7D6, idle_view );
	
	/* Decoder: Decoder ( Instr[15:0], isImm, isValid, OpALU[3:0]}, Op[3:0], OpB[3:0], OpC[3:0], CLK ) */
//	Decoder instdecode(Instr, isImm, isValid, opALU, instrOpA, instrOpB, opC, CLK);

	/* RegisterBank: RegisterBank ( AddrRegA[3:0], AddrRegB[3:0], AddrWriteReg[3:0], Data[15:0], WEN, CLK, RST, RegA[15:0]], RegB[15:0] ) */
	RegisterBank regBank(opA, opB, opC, res, wen, CLK, rst, regA, regB);

	/* ULA: ULA (OpA, OpB, Res, Op, FlagReg) */
	ULA modULA(regA, outMux, res, opALU, flagReg);

	// Mux para seleçao Imediato/Registro
	/* MUX: Mux16bit2x1 (A, B, S, SEL) */
	Mux16bit2x1 muxOpImm(regB, { 12'h000, opB }, outMux, isImm);
	
	// Mux para seleçao de operaçao/mostrar valor registro
	/* MUX: Mux4bit2x1 (A, B, S, SEL) */
	Mux4bit2x1 muxOpA(instrOpA, wRegA, opA, isView);
	
	/* MUX: Mux4bit2x1 (A, B, S, SEL) */
	Mux4bit2x1 muxOpB(instrOpB, wRegB, opB, isView);

	/* Control: Control (CLK, RST, Start, Ready, Wen, Go) */
//	Control ctrl(CLK, rst, start, ready, wen, GO);

	always @(KEY0 or KEY3) begin
		if (KEY0 == 0 && KEY3 == 1) begin			// KEY0 PRESSED
																// Mostrar conteudo dos registros
			isView		<= 1;
			idle_op		<= 1;
			idle_view	<= 0;
		end
		else if (KEY0 == 1 && KEY3 == 0) begin		// KEY3 PRESSED
																// Executar instruçao
			if ( ready ) begin
				start		= 1;
			end
			else begin
				start		= 0;
			end
			
			isView		= 0;
			idle_op		<= 0;
			idle_view	<= 1;
		end
		else begin											// IDLE
			isView		= 0;
			idle_op		<= 1;
			idle_view	<= 1;
		end
	end
	
	/* Controle para mostrar resultado no display */
	always @(posedge wen) begin
		resultado = res;
	end

endmodule
