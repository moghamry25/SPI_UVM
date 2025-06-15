package sequencer_ram;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequnce_ram_item::*;
class sequencer_ram extends uvm_sequencer#(sequnce_ram_item);
    
    `uvm_component_utils(sequencer_ram)    
    
    function new(string name = "sequencer_ram", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass    
    
endpackage