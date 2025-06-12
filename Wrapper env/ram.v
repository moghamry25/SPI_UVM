module ram (
	din,rx_valid,clk,rst_n,dout,tx_valid
	
);
	
	parameter MEM_DEPTH = 256 ;
	parameter ADDR_SIZE = 8 ;

	input [9:0]din;
	input clk,rst_n,rx_valid;

	output reg[7:0]dout;
	output reg tx_valid;

	reg [ADDR_SIZE-1:0]mem[MEM_DEPTH-1:0];
	reg [ADDR_SIZE-1:0]temp_rd,temp_wr;

	always @(posedge clk ) begin
		if (~rst_n) begin
			dout <= 0 ;
			tx_valid <= 0 ;
			temp_rd <= 0 ;
			temp_wr <= 0 ;	 
			
		end
		else begin
			if (rx_valid) begin
				case(din[9:8])

				2'b00:begin
					temp_wr <= din[7:0];
					tx_valid <= 0 ;
				end

				2'b01:begin
					mem[temp_wr] <= din[7:0];
					tx_valid <= 0;
				end
				2'b10:begin
					temp_rd<=din[7:0];
					tx_valid <= 0;
				end
				2'b11:begin

					dout <= mem[temp_rd] ;
					tx_valid <= 1;
				end
				endcase
			end
		end
	end
endmodule : ram