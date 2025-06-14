package sequence_slave_item;
`include "uvm_macros.svh"
import uvm_pkg::*;

class sequence_slave_item extends uvm_sequence_item;

    `uvm_object_utils(sequence_slave_item)

   rand logic rst_n; // Reset signal for the slave
   rand logic MOSI,SS_n,tx_valid;
   rand logic [7:0]tx_data;
   logic MISO,rx_valid,MISO_ref,rx_valid_ref;
   logic [9:0]rx_data,rx_data_ref; // Data received from the slave
    // Constructor
    function new(string name = "sequence_slave_item");
        super.new(name);
    endfunction

    // Randomization constraints

    constraint c1 {
        rst_n dist {0 := 1, 1 := 99}; // Reset signal is low for 1% of the time
        MOSI dist {0 := 75, 1 := 25}; // MOSI signal is low for 1% of the time
        SS_n dist {0 := 75, 1 := 25}; // Slave Select signal is low for 1% of the time
        tx_valid dist {0 := 50, 1 := 50}; // Transmission valid signal is low for 1% of the time
        
    }


endclass

endpackage