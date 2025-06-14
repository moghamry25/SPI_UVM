package test_wrapper;
``include "uvm_macros.svh"
import uvm_pkg::*;

class test_wrapper extends uvm_test;
    `uvm_component_utils(test_wrapper)

    // Constructor
    function new(string name = "test_wrapper", uvm_component parent = null);
        super.new(name, parent);
    endfunction // new

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);   `
        // Create the environment
         env_wrapper = env_wrapper::type_id::create("env_wrapper", this);
    endfunction // build_phase
endclass // test_wrapper extends uvm_test    

endpackage