transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/iuri/Projects/altera/Microprocessor_v17_pipeline {/home/iuri/Projects/altera/Microprocessor_v17_pipeline/Mux16bit2x1.v}
vlog -vlog01compat -work work +incdir+/home/iuri/Projects/altera/Microprocessor_v17_pipeline {/home/iuri/Projects/altera/Microprocessor_v17_pipeline/Decoder.v}
vlog -vlog01compat -work work +incdir+/home/iuri/Projects/altera/Microprocessor_v17_pipeline {/home/iuri/Projects/altera/Microprocessor_v17_pipeline/ULA.v}
vlog -vlog01compat -work work +incdir+/home/iuri/Projects/altera/Microprocessor_v17_pipeline {/home/iuri/Projects/altera/Microprocessor_v17_pipeline/RegisterBank.v}
vlog -vlog01compat -work work +incdir+/home/iuri/Projects/altera/Microprocessor_v17_pipeline {/home/iuri/Projects/altera/Microprocessor_v17_pipeline/InstrMemory.v}
vlog -vlog01compat -work work +incdir+/home/iuri/Projects/altera/Microprocessor_v17_pipeline {/home/iuri/Projects/altera/Microprocessor_v17_pipeline/Microprocessor.v}
vlog -vlog01compat -work work +incdir+/home/iuri/Projects/altera/Microprocessor_v17_pipeline {/home/iuri/Projects/altera/Microprocessor_v17_pipeline/ControlDecode.v}
vlog -vlog01compat -work work +incdir+/home/iuri/Projects/altera/Microprocessor_v17_pipeline {/home/iuri/Projects/altera/Microprocessor_v17_pipeline/ControlExecute.v}
vlog -vlog01compat -work work +incdir+/home/iuri/Projects/altera/Microprocessor_v17_pipeline {/home/iuri/Projects/altera/Microprocessor_v17_pipeline/ControlWriteback.v}

