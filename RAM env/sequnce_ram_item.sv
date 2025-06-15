package sequnce_ram_item;
import uvm_pkg::*;
`include "uvm_macros.svh"

class sequnce_ram_item extends uvm_sequence_item;
    
    `uvm_object_utils(sequnce_ram_item)
    
    rand bit [9:0] datain;
    rand bit rx_valid,rst_n;	
	logic [9:0] dout;
    logic tx_valid;
    bit tx_valid_ref;
    logic [9:0] dout_ref;
    function new(string name = "sequnce_ram_item");
        super.new(name);
    endfunction

    constraint c1{

        rst_n dist{0:=1,1:=99};
        rx_valid dist{0:=1,1:=99};
    }

   endclass 
endpackage