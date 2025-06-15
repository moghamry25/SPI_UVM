package env_wrapper;
import uvm_pkg::*;
`include "uvm_macros.svh"
import agent_wrapper::*;
import scoreboard_wrapper::*;
import coverage_wrapper::*;

class env_wrapper extends uvm_env;

    `uvm_component_utils(env_wrapper)

    agent_wrapper agt_wrapper;
    scoreboard_wrapper sb_wrapper;
    coverage_wrapper cov_wrapper;
    function new(string name = "env_wrapper", uvm_component parent = null);
        super.new(name, parent);      
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agt_wrapper = agent_wrapper::type_id::create("agt_wrapper", this);
        sb_wrapper = scoreboard_wrapper::type_id::create("sb_wrapper", this);
        cov_wrapper = coverage_wrapper::type_id::create("cov_wrapper", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the agent's analysis port to the scoreboard
        agt_wrapper.agent_ap.connect(sb_wrapper.sb_export);
        agt_wrapper.agent_ap.connect(cov_wrapper.cov_export);
    endfunction

endclass 
    
endpackage