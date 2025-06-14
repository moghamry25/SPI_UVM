interface interface_slave(clk);
    input clk;
    logic MOSI,rst_n,SS_n,tx_valid;
	logic [7:0]tx_data;
	logic MISO,rx_valid,MISO_ref,rx_valid_ref;
	logic [9:0]rx_data,rx_data_ref;
endinterface