package sequence_ram;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequnce_ram_item::*;
class sequence_ram extends uvm_sequence#(sequnce_ram_item);
    
    `uvm_object_utils(sequence_ram)
    sequnce_ram_item item;  
    function new(string name = "sequence_ram");
        super.new(name);
    endfunction
    
    task body;
        repeat(1000) begin
            
              item = sequnce_ram_item::type_id::create("item");
            start_item(item);
                assert(item.randomize());
            finish_item(item);
            
        end
    endtask
    
endclass
    
endpackage