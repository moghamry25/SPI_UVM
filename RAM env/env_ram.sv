package env_ram;
import uvm_pkg::*;
`include "uvm_macros.svh"
import agent_ram::*;
import scoreboard_ram::*;

class env_ram extends uvm_env;

    `uvm_component_utils(env_ram)

    agent_ram agt_ram;
    scoreboard_ram sb_ram;

    function new(string name = "env_ram", uvm_component parent = null);
        super.new(name, parent);      
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agt_ram = agent_ram::type_id::create("agt_ram", this);
        sb_ram = scoreboard_ram::type_id::create("sb_ram", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Connect the agent's analysis port to the scoreboard
        agt_ram.agent_ap.connect(sb_ram.sb_export);
    endfunction

endclass 
    
endpackage