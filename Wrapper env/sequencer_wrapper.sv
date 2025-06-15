package sequencer_wrapper;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_wrapper_item::*;
class sequencer_wrapper extends uvm_sequencer#(sequence_wrapper_item);
    
    `uvm_component_utils(sequencer_wrapper)    
    
    function new(string name = "sequencer_wrapper", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass    
    
endpackage