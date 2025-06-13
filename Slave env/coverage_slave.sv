package coverage_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_slave_item::*;
class coverage_slave extends uvm_component;

    `uvm_component_utils(coverage_slave)
    sequence_slave_item item;
    // Coverage export
    uvm_analysis_export#(sequence_slave_item) cov_export;
    uvm_tlm_analysis_fifo#(sequence_slave_item) cov_fifo;

    // Constructor
    function new(string name = "coverage_slave", uvm_component parent = null);
        super.new(name, parent);
        
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
           //cov1.sample();
           
            
        end
    endtask    
endclass     

    
endpackage