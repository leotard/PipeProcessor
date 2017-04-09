proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -position end sim:/ID_tb/instruction_t
    add wave -position end sim:/ID_tb/wr_in_t
    add wave -position end sim:/ID_tb/wd_in_t
    add wave -position end sim:/ID_tb/regWrite_in_t
    add wave -position end sim:/ID_tb/pc_in_t
    add wave -position end sim:/ID_tb/read_data1_t
    add wave -position end sim:/ID_tb/read_data2_t
    add wave -position end sim:/ID_tb/pc_t
    add wave -position end sim:/ID_tb/alu_op_t
    add wave -position end sim:/ID_tb/alu_src_t
    add wave -position end sim:/ID_tb/funct_t
    add wave -position end sim:/ID_tb/imm_t
    add wave -position end sim:/ID_tb/shamt_t
    add wave -position end sim:/ID_tb/dest_reg_sel_t
    add wave -position end sim:/ID_tb/dest_reg1_t
    add wave -position end sim:/ID_tb/dest_reg2_t
    add wave -position end sim:/ID_tb/branch_out_t
    add wave -position end sim:/ID_tb/memRead_out_t
    add wave -position end sim:/ID_tb/memToReg_out_t
    add wave -position end sim:/ID_tb/memWrite_out_t
    add wave -position end sim:/ID_tb/reg_write_out_t
    add wave -position end sim:/ID_tb/BNE_out_t
    add wave -position end sim:/ID_tb/Jump_out_t
    add wave -position end sim:/ID_tb/LUI_out_t
    add wave -position end sim:/ID_tb/jr_out_t

}

vlib work

;# Compile components if any
vcom ID_tb.vhd
vcom InstructionDecode.vhd
vcom ID_EX.vhd
vcom control.vhd
vcom pc_adder_shifter.vhd
vcom sign_extender.vhd
vcom registers.vhd


;# Start simulation
vsim ID_tb

;# Generate a clock with 1ns period
force -deposit clock 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 1000 ns
run 1000ns
