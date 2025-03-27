package test_ram;
`include "uvm_macros.svh"
import uvm_pkg::*;
import env_ram::*;
import config_ram::*;
import sequence_ram::*;
class test_ram extends uvm_test;
    
    `uvm_component_utils(test_ram)    
    
    env_ram env;
    config_ram cfg;
    sequence_ram seq;
    function new(string name = "test_ram", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

    env = env_ram::type_id::create("env", this); 
    cfg = config_ram::type_id::create("cfg");
    seq = sequence_ram::type_id::create("seq");
    if(!uvm_config_db#(virtual interface_ram)::get(this, "", "vif", cfg.if_ram))begin
        `uvm_fatal("build_phase", "Config object not get in test class");
    end
    uvm_config_db#(config_ram)::set(this, "*", "GFG", cfg);

    endfunction
    
    task run_phase(uvm_phase phase);

       super.run_phase(phase);

       phase.raise_objection(this);


        seq.start(env.agt_ram.seq_ram);
       `uvm_info("run_phase", "Test is done", UVM_MEDIUM)

       phase.drop_objection(this);



    endtask
    
endclass
    
endpackage