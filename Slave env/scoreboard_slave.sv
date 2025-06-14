package scoreboard_slave;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequence_slave_item::*;
class scoreboard_slave extends uvm_scoreboard;
    `uvm_component_utils(scoreboard_slave)

    sequence_slave_item item;
    int correct = 0;
    int incorrect = 0;
    ;//logic MISO_ref, rx_valid_ref;
   // logic [9:0] rx_data_ref;
  
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
        
          if (item.rx_data == item.rx_data_ref && item.rx_valid == item.rx_valid_ref && item.MISO == item.MISO_ref) begin
            correct++;
          end 
          else begin
            incorrect++;
            `uvm_error("SCOREBOARD", $sformatf("Incorrect data: Expected %0d, Got %0d", item.rx_data_ref, item.rx_data))
          end
            
        end
    endtask 
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCOREBOARD", $sformatf("Correct: %0d, Incorrect: %0d", correct, incorrect), UVM_LOW)
    endfunction
endclass
    
endpackage