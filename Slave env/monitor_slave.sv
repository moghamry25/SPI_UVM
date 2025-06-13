package monitor_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_slave_item::*;
class monitor_slave extends uvm_monitor;
    `uvm_component_utils(monitor_slave)

    virtual interface_slave if_slave;
    sequence_slave_item item;
    // Constructor
    function new(string name = "monitor_slave", uvm_component parent = null);
        super.new(name, parent);
    endfunction // new

    

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        // Monitor the virtual interface
        forever begin
        item = sequence_slave_item::type_id::create("item");

            @(negedge if_slave.clk); // Wait for clock edge

            item.rst_n = if_slave.rst_n;
            item.MOSI = if_slave.MOSI;
            item.SS_n = if_slave.SS_n;
            item.tx_valid = if_slave.tx_valid;
            item.tx_data = if_slave.tx_data;
            
            
            


        end
    endtask // run_phase

endclass // monitor_slave extends uvm_monitor    
    
endpackage