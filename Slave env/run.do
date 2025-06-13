vlib work
vlog -f src_list.list 
vsim -voptargs=+acc work.top_slave -cover -sv_seed random -classdebug -uvmcontrol=all
add wave -position insertpoint sim:/top_slave/DUT/*
#coverage save top_ram.ucdb -onexit
run -all