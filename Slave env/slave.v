module slave (
	
	MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid
	
);
	parameter IDLE = 3'b000 ;
	parameter WRITE = 3'b001 ;
	parameter CHK_CMD = 3'b010 ;
	parameter READ_ADD = 3'b011 ;
	parameter READ_DATA = 3'b100 ;



	input MOSI,clk,rst_n,SS_n,tx_valid;
	input [7:0]tx_data;
	output reg MISO,rx_valid;
	output reg[9:0]rx_data;

	reg [2:0]ns,cs;
	reg [3:0]counter;
	reg confirm_add;

	(*fsm_encoding="one_hot"*)
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			cs <= IDLE ;			
		end
		else begin
			cs <= ns ;
		end
	end

	always @(*) begin
		
		case(cs)

		IDLE:begin
			if (~SS_n) begin
				ns = CHK_CMD;
			end
			else begin
				ns = IDLE ;
			end
		end

		CHK_CMD:begin
			if (SS_n) begin
				ns = IDLE;
			end
			else if (~SS_n && ~MOSI) begin
				ns = WRITE;
			end
			else if (~SS_n && MOSI && ~confirm_add) begin
				ns = READ_ADD;
				
			end
			else if (~SS_n && MOSI && confirm_add) begin
				ns = READ_DATA;
				
			end
		end

		WRITE:begin
			if (SS_n) begin
				ns = IDLE;
			end
			else begin
				ns = WRITE;
			end
		end
		READ_ADD:begin
			if (SS_n) begin
				ns = IDLE;
			end
			else if(confirm_add)begin
				ns = READ_DATA;
			end
			else begin
				ns = READ_ADD;
			end
		end
		READ_DATA:begin
				if (SS_n) begin
					ns = IDLE;
				end
				else begin
					ns = READ_DATA;
				end
			end
		

		
         	
		default : ns = IDLE ;
		endcase	
	end

	always @(posedge clk ) begin

		if (~rst_n) begin

			counter <= 0 ;
			confirm_add <= 0 ;
			rx_data <= 0;
			rx_valid <= 0 ;
			MISO <= 0 ;
			
		end
		else begin
			case(cs)

			IDLE:begin
				counter <= 0 ;
				rx_valid <= 0 ;
				MISO <= 0 ;
			end

			WRITE:begin
				counter <= 0 ;
				if( counter < 10 ) begin
					rx_data <= {rx_data[8:0],MOSI};
					rx_valid <= 0 ;
					counter <= counter + 1 ;
				end
				 if (counter == 10) begin
					rx_valid <= 1 ;
				end
			end

			
			READ_ADD:begin 
				 if( counter < 10 ) begin
					rx_data <= {rx_data[8:0],MOSI};
					rx_valid <= 0 ;
					counter <= counter + 1 ;
				end
				if (counter == 10) begin
					rx_valid <= 1 ;
					confirm_add <= 1 ;
				end
			end
			READ_DATA:begin
			if(~tx_valid)begin
				if( counter < 10 ) begin
					rx_data <= {rx_data[8:0],MOSI};
					rx_valid <= 0 ;
					counter <= counter + 1 ;
				end
			 if (counter == 10) begin
					rx_valid <= 1 ;
					confirm_add <= 0 ;

				end
			end
			else begin
				counter <= 10 ; 
				if (3 <= counter) begin
					MISO <= tx_data[counter-3];
					counter <= counter - 1 ;
				end
			end
			end
			endcase
		end
	end
endmodule : slave