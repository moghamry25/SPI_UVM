package agent_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;
import config_slave::*;
import sequencer_slave::*;
import driver_slave::*;
class agent_slave extends uvm_agent;
`uvm_component_utils(agent_slave)

    config_slave cfg;
    sequencer_slave seq_slave;
    driver_slave drv_slave;
    function new(string name = "agent_slave", uvm_component parent = null);
        super.new(name, parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
       
        // Create the configuration object
        if(!uvm_config_db#(config_slave)::get(this, "", "GFG", cfg))begin
            `uvm_fatal("build_phase", "Config object not get in agent class")        end

             // Create the sequencer
        seq_slave = sequencer_slave::type_id::create("seq_slave", this);
        drv_slave = driver_slave::type_id::create("drv_slave", this);

        
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect the sequencer to the driver
        
        drv_slave.if_slave = cfg.if_slave;
        drv_slave.seq_item_port.connect(seq_slave.seq_item_export);
    endfunction    
endclass
    
endpackage