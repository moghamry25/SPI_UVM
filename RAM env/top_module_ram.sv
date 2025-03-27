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
 
    initial begin


        uvm_config_db#(virtual interface_ram)::set(null, "uvm_test_top", "vif", if_ram);
        run_test("test_ram");
    end

endmodule