package driver_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_slave_item::*;

class driver_slave extends uvm_driver#(sequence_slave_item);
    `uvm_component_utils(driver_slave)
    sequence_slave_item item;
    virtual interface_slave if_slave;
    // Constructor
    function new(string name = "driver_slave", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        item = sequence_slave_item::type_id::create("item");
        
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
                if_slave.rst_n = item.rst_n;
                if_slave.MOSI = item.MOSI;
                if_slave.SS_n = item.SS_n;
                if_slave.tx_valid = item.tx_valid;
                if_slave.tx_data = item.tx_data;
                @(negedge if_slave.clk); // Wait for the clock edge
                seq_item_port.item_done();
            end
        end
    endtask
 endclass // driver_slave extends uvm_driver   
    
endpackage