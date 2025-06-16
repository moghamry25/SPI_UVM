vlib work
vlog -f src_list.list 
vsim -voptargs=+acc work.top_slave -cover -sv_seed 620044377 -classdebug -uvmcontrol=all
add wave -position insertpoint sim:/top_slave/DUT/*
coverage save top_slave.ucdb -onexit
run -all
#vcover report top_slave.ucdb -details -annotate -all -output cover.txt