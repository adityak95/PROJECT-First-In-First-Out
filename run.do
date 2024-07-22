vlib work
vlog tb_asyn.v
vsim tb		+testcase=concurrent_wr_rd
#add wave -position insertpoint sim:/tb/dut/*
do wave.do
run -all
