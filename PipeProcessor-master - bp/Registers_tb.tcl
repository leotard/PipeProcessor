proc AddWaves {} {
	;#Add waves we're interested in to the Wave window
    add wave -position end sim:/Registers_tb/rd1_t
    add wave -position end sim:/Registers_tb/rd2_t
    add wave -position end sim:/Registers_tb/rr1_t
    add wave -position end sim:/Registers_tb/rr2_t
    add wave -position end sim:/Registers_tb/writeEnable_t
    add wave -position end sim:/Registers_tb/wr_t
    add wave -position end sim:/Registers_tb/wd_t

}

vlib work

;# Compile components if any
vcom registers.vhd
vcom registers_tb.vhd


;# Start simulation
vsim registers_tb

;# Generate a clock with 1ns period
force -deposit clk 0 0 ns, 1 0.5 ns -repeat 1 ns

;# Add the waves
AddWaves

;# Run for 50 ns
run 1000ns
