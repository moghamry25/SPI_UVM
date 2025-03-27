package config_ram;


`include "uvm_macros.svh"
import uvm_pkg::*;    
    class config_ram extends uvm_object;

        `uvm_object_utils(config_ram)

        virtual interface_ram if_ram;

        function new(string name = "config_ram");
            super.new(name);           
        endfunction

    endclass 

endpackage