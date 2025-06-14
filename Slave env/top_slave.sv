module top_slave();
`include "uvm_macros.svh"
import test_slave::*;
import uvm_pkg::*;
    bit clk;

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    interface_slave if_slave(clk);
    slave DUT(if_slave.MOSI,if_slave.MISO, if_slave.SS_n,if_slave.clk, if_slave.rst_n, if_slave.rx_data,if_slave.rx_valid,if_slave.tx_data, if_slave.tx_valid);
    golden_slave golden(if_slave.MOSI, 
    if_slave.clk, if_slave.rst_n,if_slave.SS_n,if_slave.tx_valid,if_slave.tx_data,if_slave.MISO_ref,if_slave.rx_valid_ref, if_slave.rx_data_ref);
    
    bind slave sva_slave sva_slave_inst(
        if_slave.clk,
        if_slave.rst_n,
        if_slave.MOSI,
        if_slave.SS_n,
        if_slave.tx_valid,
        if_slave.tx_data,
        if_slave.MISO,
        if_slave.rx_valid,
        if_slave.rx_data
    );
    initial begin

        uvm_config_db#(virtual interface_slave)::set(null, "uvm_test_top", "vif", if_slave);
        run_test("test_slave");

    end
endmodule