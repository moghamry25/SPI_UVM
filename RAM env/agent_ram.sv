package agent_ram;

`include "uvm_macros.svh"
import uvm_pkg::*;
import driver_ram::*;
import sequencer_ram::*;
import config_ram::*;
import monitor_ram::*;
import sequnce_ram_item::*;
class agent_ram extends uvm_agent;
`uvm_component_utils(agent_ram)

    driver_ram drv_ram;
    sequencer_ram seq_ram;
    config_ram cfg;
    monitor_ram mon_ram;
    uvm_analysis_port #(sequnce_ram_item) agent_ap;
    function new(string name = "agent_ram", uvm_component parent = null);
        super.new(name, parent);
        
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);


         if(!uvm_config_db#(config_ram)::get(this, "", "GFG", cfg))begin
            `uvm_fatal("build_phase", "Config object not get in agent class")
        end
        seq_ram = sequencer_ram::type_id::create("seq_ram", this); 
        drv_ram = driver_ram::type_id::create("drv_ram", this);
        mon_ram = monitor_ram::type_id::create("mon_ram", this);
        agent_ap = new("agent_ap", this);
    endfunction //build_phase()    

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv_ram.if_ram = cfg.if_ram;
        mon_ram.if_ram = cfg.if_ram;
        mon_ram.mon_ap.connect(agent_ap);
        drv_ram.seq_item_port.connect(seq_ram.seq_item_export);     
        
    endfunction

endclass //agent_ram extends uvm_agent

    
endpackage