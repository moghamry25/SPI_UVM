interface interface_ram(clk);

    input clk;
	logic [9:0]din;
    logic rx_valid,rst_n;	
	logic tx_valid;
    logic[7:0]dout;
endinterface