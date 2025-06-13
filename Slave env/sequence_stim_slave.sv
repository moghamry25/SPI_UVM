package sequence_stim_slave; //Stimulus
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_slave_item::*;
class sequence_stim_slave extends uvm_sequence#(sequence_slave_item);

    `uvm_object_utils(sequence_stim_slave)
    sequence_slave_item item;
    // Constructor
    function new(string name = "sequence_stim_slave");
        super.new(name);
    endfunction

    

    // Body phase
    virtual task body();
        sequence_slave_item item;
        
        // Create a new sequence item
        item = sequence_slave_item::type_id::create("item");
        
        repeat(1000) begin
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