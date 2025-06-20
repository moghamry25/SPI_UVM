package monitor_ram;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequnce_ram_item::*;
class monitor_ram extends uvm_monitor;
    `uvm_component_utils(monitor_ram)
    sequnce_ram_item item;
    virtual interface_ram if_ram;
    uvm_analysis_port #(sequnce_ram_item) mon_ap;

    

    function new(string name = "monitor_ram", uvm_component parent = null);
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
            item = sequnce_ram_item::type_id::create("item");
            // Wait for a valid transaction
           @(negedge if_ram.clk);
            
                item.datain = if_ram.din;
                item.rx_valid = if_ram.rx_valid;
                item.rst_n = if_ram.rst_n;
                item.dout = if_ram.dout;
                item.tx_valid = if_ram.tx_valid;
                item.dout_ref = if_ram.dout_ref;
                item.tx_valid_ref = if_ram.tx_valid_ref;
                // Send the item to the analysis export
                mon_ap.write(item);
            end
         
    endtask

endclass //monitor_ram extends uvm_monitor;
  
    
endpackage