package sequence_wrapper_item;
`include "uvm_macros.svh"
import uvm_pkg::*;

class sequence_wrapper_item extends uvm_sequence_item;

    `uvm_object_utils(sequence_wrapper_item)

    rand bit rst_n; // Reset signal, active low
    rand bit MOSI;
    rand bit SS_n; // Slave Select, active low
    bit MISO; // Master In Slave Out
    // Constructor
    function new(string name = "sequence_wrapper_item");
        super.new(name);
    endfunction

    


endclass

endpackage