package sequence_wrapper; //Stimulus
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_wrapper_item::*;
class sequence_wrapper extends uvm_sequence#(sequence_wrapper_item);

    `uvm_object_utils(sequence_wrapper)
    sequence_wrapper_item item;
    // Constructor
    function new(string name = "sequence_wrapper");
        super.new(name);
    endfunction

    

    // Body phase
    virtual task body();
        sequence_wrapper_item item;
        
        // Create a new sequence item
        item = sequence_wrapper_item::type_id::create("item");
        
        repeat(10000) begin
             // Start the item
            start_item(item);
            // Randomize the item
            assert(item.randomize());
            // Finish the item
            finish_item(item);
        end
        
       
        
        
    endtask



    

endclass
    
endpackage