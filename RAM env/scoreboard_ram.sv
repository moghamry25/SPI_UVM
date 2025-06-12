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
logic [7:0] current_dout ;  // Current dout value
logic current_tx_valid ;
logic [7:0] temp_rd ;
logic [7:0] temp_wr ;
logic [7:0] mem [0:255];

// Expected outputs
logic [7:0] expected_data ;
logic tx_valid_expected;

int error_count = 0;
int correct_count = 0;

// Constructor
function new(string name = "scoreboard_ram", uvm_component parent = null);
    super.new(name, parent);
    
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
        golden_model(item);  // Calculate expected outputs
        
        if (expected_data === item.dout && tx_valid_expected === item.tx_valid) begin
            correct_count++;
            //`uvm_info("SCOREBOARD", $sformatf("Correct transaction! datain=0x%0h rx_valid=%0b rst_n=%0b dout=0x%0h tx_valid=%0b",
              //         item.datain, item.rx_valid, item.rst_n, item.dout, item.tx_valid), UVM_MEDIUM)
        end
        else begin
            error_count++;
            `uvm_error("SCOREBOARD", $sformatf("Mismatch! datain=0x%0h rx_valid=%0b rst_n=%0b\nExpected: dout=0x%0h tx_valid=%0b\nActual:   dout=0x%0h tx_valid=%0b", 
                       item.datain, item.rx_valid, item.rst_n, expected_data, tx_valid_expected, item.dout, item.tx_valid))
        end
        //sb_fifo.item_done();
    end    
endtask 

// Golden model task - replicates RTL behavior
task golden_model(sequnce_ram_item item);
    // Calculate expected outputs for current cycle
    if (!item.rst_n) begin
        expected_data = 0;
        tx_valid_expected = 0;
    end
    else if (item.rx_valid) begin
        case (item.datain[9:8])
            2'b00, 2'b01, 2'b10: begin
                expected_data = current_dout;  // dout remains unchanged
                tx_valid_expected = 0;
            end
            2'b11: begin
                expected_data = mem[temp_rd];  // Read operation
                tx_valid_expected = 1;
            end
            default: begin
                expected_data = current_dout;
                tx_valid_expected = 0;
            end
        endcase
    end
    else begin  // No valid transaction
        expected_data = current_dout;
        tx_valid_expected = current_tx_valid;
    end

    // Update internal state for next cycle
    if (!item.rst_n) begin
        current_dout = 0;
        current_tx_valid = 0;
        temp_rd = 0;
        temp_wr = 0;
    end
    else if (item.rx_valid) begin
        case (item.datain[9:8])
            2'b00: begin  // Set write address
                temp_wr = item.datain[7:0];
                current_tx_valid = 0;
            end
            2'b01: begin  // Write data
                mem[temp_wr] = item.datain[7:0];
                current_tx_valid = 0;
            end
            2'b10: begin  // Set read address
                temp_rd = item.datain[7:0];
                current_tx_valid = 0;
            end
            2'b11: begin  // Read data
                current_dout = mem[temp_rd];  // Update dout state
                current_tx_valid = 1;
            end
        endcase
    end
endtask

function void report_phase(uvm_phase phase);
    `uvm_info("SCOREBOARD", $sformatf("Test Results: Correct=%0d Errors=%0d", correct_count, error_count), UVM_MEDIUM)
endfunction

endclass
    
endpackage