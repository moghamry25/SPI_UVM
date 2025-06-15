package env_ram;
import uvm_pkg::*;
`include "uvm_macros.svh"
import agent_ram::*;
import scoreboard_ram::*;
import coverage_ram::*;

class env_ram extends uvm_env;

    `uvm_component_utils(env_ram)

    agent_ram agt_ram;
    scoreboard_ram sb_ram;
    coverage_ram cov_ram;
    function new(string name = "env_ram", uvm_component parent = null);
        super.new(name, parent);      
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agt_ram = agent_ram::type_id::create("agt_ram", this);
        sb_ram = scoreboard_ram::type_id::create("sb_ram", this);
        cov_ram = coverage_ram::type_id::create("cov_ram", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the agent's analysis port to the scoreboard
        agt_ram.agent_ap.connect(sb_ram.sb_export);
        agt_ram.agent_ap.connect(cov_ram.cov_export);
    endfunction

endclass 
    
endpackage