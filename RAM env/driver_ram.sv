package driver_ram;

`include "uvm_macros.svh"
import uvm_pkg::*;
import config_ram::*;
import sequnce_ram_item::*;
class driver_ram extends uvm_driver#(sequnce_ram_item);

    `uvm_component_utils(driver_ram)
    virtual interface_ram if_ram;
    sequnce_ram_item item;

    function new(string name = "driver_ram", uvm_component parent = null);
        super.new(name, parent);
    endfunction




task run_phase(uvm_phase phase);

    super.run_phase(phase);
    
    forever begin
        item=sequnce_ram_item::type_id::create("item");
        seq_item_port.get_next_item(item);
        
       
        // Generate valid transactions here
        if_ram.rst_n =item.rst_n;
        if_ram.rx_valid = item.rx_valid;
        if_ram.din = item.datain;
         @(negedge if_ram.clk);
        seq_item_port.item_done();


    end
endtask


endclass

endpackage