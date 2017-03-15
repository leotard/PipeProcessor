proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -position end sim:/execution_tb/clock
    add wave -position end sim:/execution_tb/read_data1
    add wave -position end sim:/execution_tb/read_data2
    add wave -position end sim:/execution_tb/pc
    add wave -position end sim:/execution_tb/alu_op
    add wave -position end sim:/execution_tb/alu_src
    add wave -position end sim:/execution_tb/funct
    add wave -position end sim:/execution_tb/imm
    add wave -position end sim:/execution_tb/dest_reg1
    add wave -position end sim:/execution_tb/dest_reg2
    add wave -position end sim:/execution_tb/dest_reg_sel
    add wave -position end sim:/execution_tb/selected_dest
    add wave -position end sim:/execution_tb/zero_out
    add wave -position end sim:/execution_tb/alu_output
    add wave -position end sim:/execution_tb/new_pc
}

vlib work

;# Compile components if any
vcom pipeline_processor.vhd
vcom control.vhd
vcom DEST_MUX_comp.vhd
vcom PC_ADDER_SHIFTER.vhd
vcom ALU.vhd
vcom EXECUTION.vhd
vcom execution_tb.vhd

;# Start simulation
vsim execution_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 50 ns
run 50ns