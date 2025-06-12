package sequence_rst;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequnce_ram_item::*;
class sequence_rst extends uvm_sequence#(sequnce_ram_item);
    
    `uvm_object_utils(sequence_rst)
    sequnce_ram_item item;  
    function new(string name = "sequence_rst");
        super.new(name);
    endfunction
    
    task body;
        
            
              item = sequnce_ram_item::type_id::create("item");
            start_item(item);
                item.rst_n = 0; // Set reset to low
            finish_item(item);
            
        
    endtask
    
endclass
    
endpackage