package scoreboard_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_slave_item::*;
class scoreboard_slave extends uvm_scoreboard;
    `uvm_component_utils(scoreboard_slave)

    sequence_slave_item item;
    // sberage export
    uvm_analysis_export#(sequence_slave_item) sb_export;
    uvm_tlm_analysis_fifo#(sequence_slave_item) sb_fifo;

    // Constructor
    function new(string name = "scoreboard_slave", uvm_component parent = null);
        super.new(name, parent);
        
    endfunction

   function void build_phase(uvm_phase phase);
        super.build_phase(phase);
       sb_export = new("sb_export", this);
         sb_fifo = new("sb_fifo", this);

    endfunction
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect the export to the FIFO
        sb_export.connect(sb_fifo.analysis_export);
    endfunction    

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            // Wait for an item to be written to the FIFO
        sb_fifo.get(item);
        
           
            
        end
    endtask 
    
    
endclass
    
endpackage