transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor {C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor/Mux16bit2x1.v}
vlog -vlog01compat -work work +incdir+C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor {C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor/Decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor {C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor/ULA.v}
vlog -vlog01compat -work work +incdir+C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor {C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor/Control.v}
vlog -vlog01compat -work work +incdir+C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor {C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor/RegisterBank.v}
vlog -vlog01compat -work work +incdir+C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor {C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor/InstrMemory.v}
vlog -vlog01compat -work work +incdir+C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor {C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor/Microprocessor.v}
vlog -vlog01compat -work work +incdir+C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor {C:/Users/Ricardo/Documents/GitHub/arquitetura_de_computadores/Microprocessor/Mult.v}

