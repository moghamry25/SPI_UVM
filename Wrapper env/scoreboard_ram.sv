package scoreboard_ram;
`include "uvm_macros.svh"
import uvm_pkg::*;
import sequnce_ram_item::*;

class scoreboard_ram extends uvm_scoreboard;
    `uvm_component_utils(scoreboard_ram)

    uvm_analysis_export #(sequnce_ram_item) sb_export;
    uvm_tlm_analysis_fifo #(sequnce_ram_item) sb_fifo;
    sequnce_ram_item item;

    // Golden model state variables
    logic [7:0] current_dout = 0;   // Current dout value
    logic current_tx_valid = 0;
    logic [7:0] temp_rd = 0;
    logic [7:0] temp_wr = 0;
    logic [7:0] mem [256];  // Uninitialized memory

    // Expected outputs
    logic [7:0] expected_data;
    logic tx_valid_expected;

    int error_count = 0;
    int correct_count = 0;

    // Constructor
    function new(string name = "scoreboard_ram", uvm_component parent = null);
        super.new(name, parent);
        // Initialize memory to unknown (matches RTL)
        foreach(mem[i]) mem[i] = 'x;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
        sb_fifo = new("sb_fifo", this);
    endfunction    

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            sb_fifo.get(item);
           // golden_model(item);  // Calculate expected outputs
            
            if (item.dout_ref=== item.dout && item.tx_valid_ref === item.tx_valid) begin
                correct_count++;
            end
            else begin
                error_count++;
                `uvm_error("SCOREBOARD", $sformatf("Mismatch! datain=0x%0h rx_valid=%0b rst_n=%0b\nExpected: dout=0x%0h tx_valid=%0b\nActual:   dout=0x%0h tx_valid=%0b", 
                          item.datain, item.rx_valid, item.rst_n, item.dout_ref, item.tx_valid_ref, item.dout, item.tx_valid))
            end
        end    
    endtask 

    // Golden model task - replicates RTL behavior
    task golden_model(sequnce_ram_item item);
        // Default outputs retain previous values
        expected_data = current_dout;
        tx_valid_expected = current_tx_valid;
        
        if (!item.rst_n) begin
            // Reset clears registers but NOT memory
            expected_data = 0;
            tx_valid_expected = 0;
            
            // Update next state (for next cycle)
            current_dout = 0;
            current_tx_valid = 0;
            temp_rd = 0;
            temp_wr = 0;
        end
        else if (item.rx_valid) begin
            case (item.datain[9:8])
                2'b00: begin  // Set write address
                    temp_wr = item.datain[7:0];
                    current_tx_valid = 0;  // For next cycle
                end
                2'b01: begin  // Write data
                    mem[temp_wr] = item.datain[7:0];
                    current_tx_valid = 0;  // For next cycle
                end
                2'b10: begin  // Set read address
                    temp_rd = item.datain[7:0];
                    current_tx_valid = 0;  // For next cycle
                end
                2'b11: begin  // Read data
                    // Output updates immediately
                    expected_data = mem[temp_rd];
                    tx_valid_expected = 1;
                    
                    // Update state for next cycle
                    current_dout = mem[temp_rd];
                    current_tx_valid = 1;
                end
            endcase
        end
    endtask

    function void report_phase(uvm_phase phase);
        `uvm_info("SCOREBOARD", $sformatf("Test Results: Correct=%0d Errors=%0d", 
                  correct_count, error_count), UVM_MEDIUM)
    endfunction
endclass
endpackage