package env_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;
import agent_slave::*;
import config_slave::*;


class env_slave extends uvm_env;
    `uvm_component_utils(env_slave)

    // Configuration object
    config_slave cfg;
    agent_slave agt_slave;
    // Constructor
    function new(string name = "env_slave", uvm_component parent = null);
        super.new(name, parent);
    endfunction // new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Create the configuration object
        cfg = config_slave::type_id::create("cfg");
        agt_slave = agent_slave::type_id::create("agt_slave", this);
       

        
    endfunction // build_phase
endclass // env_slave extends uvm_env    
    
endpackage