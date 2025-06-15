package coverage_wrapper;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_wrapper_item::*;
class coverage_wrapper extends uvm_component;

    `uvm_component_utils(coverage_wrapper)
    sequence_wrapper_item item;
    // Coverage export
    uvm_analysis_export#(sequence_wrapper_item) cov_export;
    uvm_tlm_analysis_fifo#(sequence_wrapper_item) cov_fifo;

    // functional coverage 
    // uvm_covergroup cov1;

    covergroup cov1;

    coverpoint item.MOSI {
        option.comment = "Covering MISO";
        bins miso_bins[] = {0, 1};
    }
    coverpoint item.SS_n {
        option.comment = "Covering SS_n";
        bins ss_bins[] = {0, 1};
    }
    coverpoint item.rst_n {
        option.comment = "Covering rst_n";
        bins rst_bins[] = {0, 1};
    }
    coverpoint item.MOSI {
        option.comment = "Covering MOSI";
        bins mosi_bins[] = {0, 1};
    }
    endgroup

    // Constructor
    function new(string name = "coverage_wrapper", uvm_component parent = null);
        super.new(name, parent);
        cov1 = new();
    endfunction

   function void build_phase(uvm_phase phase);
        super.build_phase(phase);
       cov_export = new("cov_export", this);
         cov_fifo = new("cov_fifo", this);

    endfunction
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect the export to the FIFO
        cov_export.connect(cov_fifo.analysis_export);
    endfunction    

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            // Wait for an item to be written to the FIFO
        cov_fifo.get(item);
        cov1.sample();
           
            
        end
    endtask    
endclass     

    
endpackage