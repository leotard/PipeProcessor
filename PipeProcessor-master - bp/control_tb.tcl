proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -position end sim:/Control_tb/op_code_t
    add wave -position end sim:/Control_tb/reg_w_t
    add wave -position end sim:/Control_tb/reg_dst_t
    add wave -position end sim:/Control_tb/mem_reg_t

}

vlib work

;# Compile components if any
vcom control.vhd
vcom control_tb.vhd


;# Start simulation
vsim Control_tb

;# Generate a clock with 1ns period
#force -deposit clock 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 50 ns
run 600ns
