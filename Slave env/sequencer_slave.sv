package sequencer_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_slave_item::*;
class sequencer_slave extends uvm_sequencer#(sequence_slave_item);
    
    `uvm_component_utils(sequencer_slave)    
    
    function new(string name = "sequencer_slave", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass    
    
endpackage