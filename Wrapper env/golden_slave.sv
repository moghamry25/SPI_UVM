module golden_slave (
    input MOSI, clk, rst_n, SS_n, tx_valid,
    input [7:0] tx_data,
    output reg MISO, rx_valid,
    output reg [9:0] rx_data
);
    // State definitions - must match RTL exactly
    parameter IDLE      = 3'b000;
    parameter WRITE     = 3'b001;
    parameter CHK_CMD   = 3'b010;
    parameter READ_ADD  = 3'b011;
    parameter READ_DATA = 3'b100;

    reg [2:0] cs, ns;
    reg [3:0] counter;
    reg confirm_add;
    reg [9:0] rx_data_internal;
    
   (*fsm_encoding="one_hot"*)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cs <= IDLE;
            counter <= 0;
            confirm_add <= 0;
            rx_data_internal <= 0;
            MISO <= 0;
            rx_valid <= 0;
        end
        else begin
           cs <= ns;
            
            // State behavior
            case (cs)
                IDLE: begin
                    counter <= 0;
                    rx_valid <= 0;
                    MISO <= 0;
                end
                
                WRITE: begin
                    counter <= 0 ;
                    if (counter < 10) begin
                        rx_data_internal <= {rx_data_internal[8:0], MOSI};
                        counter <= counter + 1;
                        rx_valid <= 0;
                    end
                    else if (counter == 10) begin
                        rx_valid <= 1;
                    end
                end
                
                READ_ADD: begin
                    if (counter < 10) begin
                        rx_data_internal <= {rx_data_internal[8:0], MOSI};
                        counter <= counter + 1;
                        rx_valid <= 0;
                    end
                    else if (counter == 10) begin
                        rx_valid <= 1;
                        confirm_add <= 1;
                    end
                end
                
                READ_DATA: begin
                    if (!tx_valid) begin
                        if (counter < 10) begin
                            rx_data_internal <= {rx_data_internal[8:0], MOSI};
                            counter <= counter + 1;
                            rx_valid <= 0;
                        end
                        else if (counter == 10) begin
                            rx_valid <= 1;
                            confirm_add <= 0;
                        end
                    end
                    else begin
                        counter <= 10;
                        if (counter >= 3 && counter <= 10) begin
                            MISO <= tx_data[counter-3];
                            counter <= counter - 1;
                        end
                    end
                end
                
                default: begin
                    // Safe default
                    counter <= 0;
                    rx_valid <= 0;
                    MISO <= 0;
                end
            endcase
        end
    end
    
    // Next state logic (combinational)
    always @(*) begin
        case (cs)
            IDLE: begin
                ns = (~SS_n) ? CHK_CMD : IDLE;
            end
            
            CHK_CMD: begin
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
                else begin
                    ns = CHK_CMD;
                end
            end
            
            WRITE: begin
                ns = SS_n ? IDLE : WRITE;
            end
            
            READ_ADD: begin
                if (SS_n) begin
                    ns = IDLE;
                end
                else if (confirm_add) begin
                    ns = READ_DATA;
                end
                else begin
                    ns = READ_ADD;
                end
            end
            
            READ_DATA: begin
                ns = SS_n ? IDLE : READ_DATA;
            end
            
            default: ns = IDLE;
        endcase
    end
    
    // Output assignment
    assign rx_data = rx_data_internal;
endmodule