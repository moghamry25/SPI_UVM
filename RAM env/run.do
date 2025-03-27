vlib work
vlog -f src_files.list 
vsim -voptargs=+acc work.top_module_ram -cover -sv_seed random -classdebug -uvmcontrol=all
add wave -position insertpoint sim:/top_module_ram/DUT/*
#coverage save top_ram.ucdb -onexit
run -all
#vcover report top_ram.ucdb -details -annotate -all -output cover.txt