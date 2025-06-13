package sequence_rst_slave; //Stimulus
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_slave_item::*;
class sequence_rst_slave extends uvm_sequence#(sequence_slave_item);

    `uvm_object_utils(sequence_rst_slave)
    sequence_slave_item item;
    // Constructor
    function new(string name = "sequence_rst_slave");
        super.new(name);
    endfunction

    

    // Body phase
    virtual task body();
        
        
        // Create a new sequence item
        item = sequence_slave_item::type_id::create("item");
        
        
            start_item(item);
            // rst 

            item.rst_n = 0; // Set reset to low


            // Finish the item
            finish_item(item);
        
        
       
        
        
    endtask



    

endclass
    
endpackage