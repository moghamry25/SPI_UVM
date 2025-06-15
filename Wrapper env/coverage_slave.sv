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

    // functional coverage 
    // uvm_covergroup cov1;

    covergroup cov1;

    Covering_rx_data:coverpoint item.rx_data {
        option.comment = "Covering rx_data";
        bins data_bins[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    }
   Covering_rx_valid: coverpoint item.rx_valid {
        option.comment = "Covering rx_valid";
        bins valid_bins[] = {0, 1};
    }
    Covering_MISO:coverpoint item.MISO {
        option.comment = "Covering MISO";
        bins miso_bins[] = {0, 1};
    }
    Covering_SS_n:coverpoint item.SS_n {
        option.comment = "Covering SS_n";
        bins ss_bins[] = {0, 1};
    }

    Covering_tx_valid:coverpoint item.tx_valid {
        option.comment = "Covering tx_valid";
        bins tx_valid_bins[] = {0, 1};
    }

    Covering_tx_data:coverpoint item.tx_data {
        option.comment = "Covering tx_data";
        bins tx_data_bins[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    }
    Covering_rst_n:coverpoint item.rst_n {
        option.comment = "Covering rst_n";
        bins rst_bins[] = {0, 1};
    }
    
    

    endgroup

    // Constructor
    function new(string name = "coverage_slave", uvm_component parent = null);
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