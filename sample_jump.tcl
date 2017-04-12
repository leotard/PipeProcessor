proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
       add wave -position end sim:/processor_tb/clk 
	add wave -position end sim:/processor_tb/dut/Fetch/IR
	add wave -position end sim:/processor_tb/registers_out(4)
	add wave -position end sim:/processor_tb/registers_out(31)
	add wave -position end sim:/processor_tb/registers_out(32)
	add wave -position end sim:/processor_tb/registers_out(3)
	add wave -position end sim:/processor_tb/dut/Fetch/data_stall
   

}

vlib work

;# Compile components if any
vcom control.vhd
vcom DEST_MUX_comp.vhd
vcom PC_ADDER_SHIFTER.vhd
vcom ALU.vhd
vcom EXECUTION.vhd
vcom processor.vhd
vcom registers.vhd
vcom ID_EX.vhd
vcom processor_tb.vhd
vcom sign_extender.vhd
vcom instructiondecode.vhd
vcom instructionfetch.vhd
vcom muxtwo.vhd
vcom instructionmem.vhd
vcom PC_adder.vhd
vcom hazarddetection.vhd
vcom mem_stage.vhd
vcom muxasync.vhd
vcom memory.vhd
vcom writeBack.vhd
vcom dest_mux_comp.vhd
vcom pkg.vhd


;# Start simulation
vsim processor_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 50 ns
run 50ns
