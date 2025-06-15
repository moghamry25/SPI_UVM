`include "uvm_macros.svh" 
import uvm_pkg::*;
import test_ram::*;
module top_module_ram();
    
    bit clk;

    initial begin
        
        forever begin
            #5 clk = ~clk;
        end
    end

    interface_ram if_ram(clk);
    ram DUT(if_ram.din, if_ram.rx_valid, if_ram.clk, if_ram.rst_n, if_ram.dout, if_ram.tx_valid);
    golden_ram golden_ram(if_ram.din, if_ram.rx_valid, if_ram.clk, if_ram.rst_n, if_ram.dout_ref, if_ram.tx_valid_ref);

    bind ram sva_ram sva_ram_inst(.clk(if_ram.clk), .rst_n(if_ram.rst_n), .rx_valid(if_ram.rx_valid), .tx_valid(if_ram.tx_valid), .datain(if_ram.din), .dout(if_ram.dout));
    initial begin


        uvm_config_db#(virtual interface_ram)::set(null, "uvm_test_top", "vif", if_ram);
        run_test("test_ram");
    end

endmodule