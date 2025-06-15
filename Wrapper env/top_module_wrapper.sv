module top_module_wrapper();
`include "uvm_macros.svh"
import uvm_pkg::*;
import test_wrapper::*;
    bit clk;
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

interface_wrapper if_wrapper(clk);
interface_slave if_slave(clk);
interface_ram if_ram(clk);

ram DUT_ram(if_ram.din, if_ram.rx_valid, if_ram.clk, if_ram.rst_n, if_ram.dout, if_ram.tx_valid);
slave DUT_slave(if_slave.MOSI,if_slave.MISO, if_slave.SS_n,if_slave.clk, if_slave.rst_n, if_slave.rx_data,if_slave.rx_valid,if_slave.tx_data, if_slave.tx_valid);
 golden_slave golden(if_slave.MOSI, 
    if_slave.clk, if_slave.rst_n,if_slave.SS_n,if_slave.tx_valid,if_slave.tx_data,if_slave.MISO_ref,if_slave.rx_valid_ref, if_slave.rx_data_ref);
    
wrapper DUT_wrapper(if_wrapper.MOSI, if_wrapper.MISO, if_wrapper.SS_n, if_wrapper.clk, if_wrapper.rst_n);   
golden_wrapper golden_wrapper(if_wrapper.MOSI,if_wrapper.SS_n ,if_wrapper.clk, if_wrapper.rst_n,if_wrapper.MISO_ref);

assign if_slave.MOSI=DUT_wrapper.MOSI;
assign if_slave.SS_n=DUT_wrapper.SS_n;
assign if_slave.rst_n=DUT_wrapper.rst_n;
assign if_ram.din=if_slave.rx_data;
assign if_ram.rx_valid=if_slave.rx_valid;
assign if_slave.tx_data=if_ram.dout;
assign if_slave.tx_valid=if_ram.tx_valid;
assign if_ram.rst_n=DUT_wrapper.rst_n;    
initial begin

    uvm_config_db#(virtual interface_wrapper)::set(null, "uvm_test_top", "vif", if_wrapper);
    uvm_config_db#(virtual interface_slave)::set(null, "uvm_test_top", "vif_slave", if_slave);
    uvm_config_db#(virtual interface_ram)::set(null, "uvm_test_top", "vif_ram", if_ram);
        run_test("test_wrapper");
    
end    




endmodule