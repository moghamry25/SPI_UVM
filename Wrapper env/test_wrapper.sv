package test_wrapper;
`include "uvm_macros.svh"
import uvm_pkg::*;
import env_wrapper::*;
import env_slave::*;
import env_ram::*;
import config_slave::*;
import config_wrapper::*;
import config_ram::*;
import sequence_wrapper_item::*;
import sequence_rst_wrapper::*;
class test_wrapper extends uvm_test;
    `uvm_component_utils(test_wrapper)
    env_wrapper env_wrapperr;
    env_slave env_slaver;
    env_ram env_ramm;
    config_slave cfg_slave;
    config_wrapper cfg_wrapper;
    config_ram cfg_ram;
    sequence_rst_wrapper seq_rst_wrapper;
    // Constructor
    function new(string name = "test_wrapper", uvm_component parent = null);
        super.new(name, parent);
    endfunction // new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);   
        // Create the environment
        env_wrapperr = env_wrapper::type_id::create("env_wrapperr", this);
        env_slaver = env_slave::type_id::create("env_slaver", this);
        env_ramm = env_ram::type_id::create("env_ramm", this);

        // Create the configuration objects
        cfg_slave = config_slave::type_id::create("cfg_slave", this);
        cfg_wrapper = config_wrapper::type_id::create("cfg_wrapper", this);
        cfg_ram = config_ram::type_id::create("cfg_ram", this);

        seq_rst_wrapper = sequence_rst_wrapper::type_id::create("seq_rst_wrapper", this);

        // get the configuration objects in the UVM config database
        if (!uvm_config_db#(virtual interface_slave)::get(this, "", "vif_slave", cfg_slave.if_slave)) begin
            `uvm_fatal("build_phase", "Config object not get in test class");
        end
        if (!uvm_config_db#(virtual interface_wrapper)::get(this, "", "vif", cfg_wrapper.if_wrapper)) begin
            `uvm_fatal("build_phase", "Config object not get in test class");
        end
        if (!uvm_config_db#(virtual interface_ram)::get(this, "", "vif_ram", cfg_ram.if_ram)) begin
            `uvm_fatal("build_phase", "Config object not get in test class");
        end
        // Set the configuration objects in the database
        uvm_config_db#(config_slave)::set(this, "*", "GFG_slave", cfg_slave);
        uvm_config_db#(config_wrapper)::set(this, "*", "GFG", cfg_wrapper);
        uvm_config_db#(config_ram)::set(this, "*", "GFG_ram", cfg_ram);


    endfunction // build_phase

    // Run phase
    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        // Raise an objection to keep the test running
        phase.raise_objection(this);

        seq_rst_wrapper.start(env_wrapperr.agt_wrapper.seq_wrapper);
        `uvm_info("run_phase", "Wrapper sequence started", UVM_MEDIUM)
        

        // Drop the objection when done
        phase.drop_objection(this);
    endtask // run_phase

endclass // test_wrapper extends uvm_test    

endpackage