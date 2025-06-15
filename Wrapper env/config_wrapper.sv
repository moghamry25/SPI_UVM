package config_wrapper;
`include "uvm_macros.svh"
import uvm_pkg::*;

class config_wrapper extends uvm_object;
    `uvm_object_utils(config_wrapper)

    // Virtual interface for the wrapper
    virtual interface_wrapper if_wrapper;

    // Constructor
    function new(string name = "config_wrapper");
        super.new(name);
    endfunction

   
endclass    
    
endpackage