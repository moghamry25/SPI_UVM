package agent_wrapper;

`include "uvm_macros.svh"
import uvm_pkg::*;
import driver_wrapper::*;
import sequencer_wrapper::*;
import config_wrapper::*;
import monitor_wrapper::*;
import sequence_wrapper_item::*;
class agent_wrapper extends uvm_agent;
`uvm_component_utils(agent_wrapper)

    driver_wrapper drv_wrapper;
    sequencer_wrapper seq_wrapper;
    config_wrapper cfg;
    monitor_wrapper mon_wrapper;
    uvm_analysis_port #(sequence_wrapper_item) agent_ap;
    
    function new(string name = "agent_wrapper", uvm_component parent = null);
        super.new(name, parent);
        
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);


         if(!uvm_config_db#(config_wrapper)::get(this, "", "GFG", cfg))begin
            `uvm_fatal("build_phase", "Config object not get in agent class")
        end
        seq_wrapper = sequencer_wrapper::type_id::create("seq_wrapper", this); 
        drv_wrapper = driver_wrapper::type_id::create("drv_wrapper", this);
        mon_wrapper = monitor_wrapper::type_id::create("mon_wrapper", this);
        agent_ap = new("agent_ap", this);
    endfunction //build_phase()    

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv_wrapper.if_wrapper = cfg.if_wrapper;
        mon_wrapper.if_wrapper = cfg.if_wrapper;
        mon_wrapper.mon_ap.connect(agent_ap);
        drv_wrapper.seq_item_port.connect(seq_wrapper.seq_item_export);     
        
    endfunction

endclass //agent_wrapper extends uvm_agent

    
endpackage