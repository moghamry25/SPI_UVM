package config_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;

class config_slave extends uvm_object;
    `uvm_object_utils(config_slave)

    // Virtual interface for the slave
    virtual interface_slave if_slave;

    // Constructor
    function new(string name = "config_slave");
        super.new(name);
    endfunction

   
endclass    
    
endpackage