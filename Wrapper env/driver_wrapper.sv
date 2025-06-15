package driver_wrapper;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_wrapper_item::*;

class driver_wrapper extends uvm_driver#(sequence_wrapper_item);
    `uvm_component_utils(driver_wrapper)
    sequence_wrapper_item item;
    virtual interface_wrapper if_wrapper;
    // Constructor
    function new(string name = "driver_wrapper", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        item = sequence_wrapper_item::type_id::create("item");
        
    endfunction // build_phase    
    // Main task to drive the sequence item
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        

        forever begin
            // Get the next item from the sequencer
            seq_item_port.get_next_item(item);

            // Drive the item to the virtual interface
            if (item != null) begin
                // Add your driving logic here
                if_wrapper.rst_n = item.rst_n;
                if_wrapper.MOSI = item.MOSI;
                if_wrapper.SS_n = item.SS_n;
               

                @(negedge if_wrapper.clk); // Wait for the clock edge
                seq_item_port.item_done();
            end
        end
    endtask
 endclass // driver_wrapper extends uvm_driver   
    
endpackage