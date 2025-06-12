package coverage_ram;
import uvm_pkg::*;
`include "uvm_macros.svh"
import sequnce_ram_item::*;
class coverage_ram extends uvm_component;
    `uvm_component_utils(coverage_ram)

    uvm_analysis_export #(sequnce_ram_item) cov_export;
    uvm_tlm_analysis_fifo #(sequnce_ram_item) cov_fifo;
    sequnce_ram_item item;

    covergroup cov1 ;
        coverpoint item.datain[9:8] {
            bins bin_00 = {2'b00};
            bins bin_01 = {2'b01};
            bins bin_10 = {2'b10};
            bins bin_11 = {2'b11};
            bins bin_trafser_write = (2'b00 => 2'b01);
            bins bin_trafser_read = (2'b10 => 2'b11);
            
        }

        coverpoint item.datain[7:0] {
            bins bin_00 = {8'h00};
            bins bin_ff = {8'hff};
            bins bin_7f = {8'h7f};
            bins bin_AA = {8'hAA};
            bins bin_55 = {8'h55};
        }

        coverpoint item.rx_valid {
            bins valid = {1'b1};
            bins invalid = {1'b0};
        }

        coverpoint item.rst_n {
            bins reset = {1'b0};
            bins no_reset = {1'b1};
        }   

        coverpoint item.tx_valid {
            bins valid = {1'b1};
            bins invalid = {1'b0};
        }

        
    endgroup

function new(string name = "coverage_ram ", uvm_component parent = null);
        super.new(name, parent);
        cov1=new();
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
           cov1.sample();
           
            
        end
    endtask
    

    
endclass    
    
endpackage