package test_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;
import env_slave::*;
import sequence_rst_slave::*;
import sequence_stim_slave::*;
import config_slave::*;

class test_slave extends uvm_test;
    `uvm_component_utils(test_slave)
    env_slave env; // Environment for the slave
    config_slave cfg; // Configuration object for the slave
    sequence_rst_slave seq_rst_slave; // Sequence for reset operation
    sequence_stim_slave seq_stim_slave; // Sequence for stimulus operation
    // Constructor
    function new(string name = "test_slave", uvm_component parent = null);
        super.new(name, parent);
        
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create the environment
       env = env_slave::type_id::create("env", this);
        
        // Create the configuration object

       cfg = config_slave::type_id::create("cfg");
        seq_rst_slave = sequence_rst_slave::type_id::create("seq_rst_slave");
        seq_stim_slave = sequence_stim_slave::type_id::create("seq_stim_slave");
        
        
        // Get the virtual interface from the configuration database
        if (!uvm_config_db#(virtual interface_slave)::get(this, "", "vif", cfg.if_slave)) begin
            `uvm_fatal("build_phase", "Config object not get in test class");
        end
        
        // Set the configuration object in the database
        uvm_config_db#(config_slave)::set(this, "*", "GFG", cfg);

    endfunction //build_phase   

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        // Raise an objection to keep the test running
        phase.raise_objection(this);
        
        // Start the sequences
        seq_rst_slave.start(env.agt_slave.seq_slave);
        `uvm_info("run_phase", "Slave sequence started", UVM_MEDIUM)
        seq_stim_slave.start(env.agt_slave.seq_slave);
        `uvm_info("run_phase", "Stimulus sequence started", UVM_MEDIUM)
        
        `uvm_info("run_phase", "Test is running", UVM_MEDIUM)
        
        // Drop the objection when done
        phase.drop_objection(this); 
    endtask //run_phase
endclass //test_slave extends uvm_test
    
endpackage