vlib work
vlog -f src_list.list 
vsim -voptargs=+acc work.top_module_wrapper -cover -sv_seed 620044377 -classdebug -uvmcontrol=all
add wave -position insertpoint sim:/top_module_wrapper/DUT_ram/*
add wave -position insertpoint sim:/top_module_wrapper/DUT_slave/*
add wave -position insertpoint sim:/top_module_wrapper/DUT_wrapper/*
#coverage save top_module_wrapper.ucdb -onexit
run -all