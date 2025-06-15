package monitor_wrapper;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_wrapper_item::*;
class monitor_wrapper extends uvm_monitor;
    `uvm_component_utils(monitor_wrapper)
    sequence_wrapper_item item;
    virtual interface_wrapper if_wrapper;
    uvm_analysis_port #(sequence_wrapper_item) mon_ap;

    

    function new(string name = "monitor_wrapper", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Create the analysis port
        mon_ap = new("mon_ap", this);
    endfunction    

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            item = sequence_wrapper_item::type_id::create("item");
            // Wait for a valid transaction
           @(negedge if_wrapper.clk);
            
                item.MOSI = if_wrapper.MOSI;
                item.MISO = if_wrapper.MISO;
                item.rst_n = if_wrapper.rst_n;
                item.SS_n = if_wrapper.SS_n;
                
                
                // Send the item to the analysis export
                mon_ap.write(item);
            end
         
    endtask

endclass //monitor_wrapper extends uvm_monitor;
  
    
endpackage