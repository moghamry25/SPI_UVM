package sequence_wrapper_item;
`include "uvm_macros.svh"
import uvm_pkg::*;

class sequence_wrapper_item extends uvm_sequence_item;

    `uvm_object_utils(sequence_wrapper_item)

    rand bit rst_n; // Reset signal, active low
    rand bit MOSI;
    rand bit SS_n; // Slave Select, active low
    bit MISO,MISO_ref; // Master In Slave Out
    // Constructor
    function new(string name = "sequence_wrapper_item");
        super.new(name);
    endfunction

    constraint c1 {
        rst_n dist {0 := 1, 1 := 99}; // Reset signal is low for 1% of the time
        MOSI dist {0 := 75, 1 := 25}; // MOSI signal is low for 1% of the time
        SS_n dist {0 := 75, 1 := 25}; // Slave Select signal is low for 1% of the time
        
    }

    


endclass

endpackage