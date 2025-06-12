module wrapper (
	
	MOSI,MISO,SS_n,clk,rst_n
	
);
	

	input MOSI,SS_n,clk,rst_n;
	output MISO ;

	wire [9:0]rx_data;
	wire rx_valid,tx_valid;
	wire [7:0]tx_data;

	slave S1(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);

	ram RAM(rx_data,rx_valid,clk,rst_n,tx_data,tx_valid);
endmodule : wrapper