onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/dut/wr_clk
add wave -noupdate /tb/dut/rd_clk
add wave -noupdate /tb/dut/rst
add wave -noupdate /tb/dut/empty
add wave -noupdate /tb/dut/wr_en
add wave -noupdate -radix unsigned /tb/dut/wr_ptr
add wave -noupdate -radix unsigned /tb/dut/wr_ptr_rd_clk
add wave -noupdate -radix hexadecimal /tb/dut/w_data
add wave -noupdate /tb/dut/wr_t_rd_clk
add wave -noupdate /tb/dut/wr_t
add wave -noupdate /tb/dut/full
add wave -noupdate /tb/dut/wr_error
add wave -noupdate /tb/dut/rd_en
add wave -noupdate /tb/dut/rd_error
add wave -noupdate -radix unsigned /tb/dut/rd_ptr
add wave -noupdate -radix unsigned /tb/dut/rd_ptr_wr_clk
add wave -noupdate -radix hexadecimal /tb/dut/r_data
add wave -noupdate /tb/dut/rd_t
add wave -noupdate /tb/dut/rd_t_wr_clk
add wave -noupdate /tb/dut/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {189 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {38 ps} {575 ps}
