package coverage_ram;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sequnce_ram_item::*;
class coverage_ram extends uvm_component;
    `uvm_component_utils(coverage_ram)

    uvm_analysis_export #(sequnce_ram_item) cov_export;
    uvm_tlm_analysis_fifo #(sequnce_ram_item) cov_fifo;
    sequnce_ram_item item;
function new(string name = "coverage_ram ", uvm_component parent = null);
        super.new(name, parent);
    endfunction //new()
function void build_phase(uvm_phase phase);
        super.build_phase(phase);
       cov_export = new("cov_export", this);
        cov_fifo = new("cov_fifo");
        // Register the analysis export with the FIFO
    
    endfunction //build_phase()

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
            cov_export.connect(cov_fifo.analysis_export);
    endfunction //connect_phase()

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            // Wait for an item to be written to the FIFO
            cov_fifo.get(item);
            
        end
    endtask
    

    
endclass    
    
endpackage