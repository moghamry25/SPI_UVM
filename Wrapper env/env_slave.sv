package env_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;
import agent_slave::*;
import config_slave::*;
import coverage_slave::*;
import scoreboard_slave::*;
class env_slave extends uvm_env;
    `uvm_component_utils(env_slave)


    agent_slave agt_slave;
    coverage_slave cov_slave;
    scoreboard_slave sb_slave;
    // Constructor
    function new(string name = "env_slave", uvm_component parent = null);
        super.new(name, parent);
    endfunction // new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

     
        agt_slave = agent_slave::type_id::create("agt_slave", this);
        cov_slave = coverage_slave::type_id::create("cov_slave", this);
        sb_slave = scoreboard_slave::type_id::create("sb_slave", this);
       

        
    endfunction // build_phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the agent's analysis port to the coverage
        agt_slave.agent_cov_ap.connect(cov_slave.cov_export);
        agt_slave.agent_cov_ap.connect(sb_slave.sb_export);       
    endfunction    
endclass // env_slave extends uvm_env    
    
endpackage