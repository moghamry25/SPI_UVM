module golden_wrapper #(
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
)(
    input logic MOSI,
    input logic SS_n,
    input logic clk,
    input logic rst_n,
    output logic MISO
);

    // FSM states
    typedef enum {
        IDLE,
        CHK_CMD,
        WRITE,
        READ_ADD,
        READ_DATA
    } state_t;

    // Internal signals
    state_t current_state, next_state;
    logic [9:0] rx_shift;
    logic [9:0] ram_din;
    logic rx_valid;
    logic [7:0] ram_dout;
    logic ram_tx_valid;
    logic [3:0] bit_counter;
    logic confirm_add;
    logic last_ssn;

    // RAM model
    logic [7:0] mem [0:MEM_DEPTH-1];
    logic [ADDR_SIZE-1:0] temp_rd, temp_wr;
    
    // Slave output register
    logic miso_reg;

    

    // FSM state transition
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
            last_ssn <= 1'b1;
        end else begin
            current_state <= next_state;
            last_ssn <= SS_n;
        end
    end

    // FSM next state logic
    always_comb begin
        next_state = current_state;
        case (current_state)
            IDLE: begin
                if (!SS_n) next_state = CHK_CMD;
            end
            CHK_CMD: begin
                if (SS_n) begin
                    next_state = IDLE;
                end else if (!MOSI) begin
                    next_state = WRITE;
                end else if (MOSI && !confirm_add) begin
                    next_state = READ_ADD;
                end else if (MOSI && confirm_add) begin
                    next_state = READ_DATA;
                end
            end
            WRITE: begin
                if (SS_n) next_state = IDLE;
            end
            READ_ADD: begin
                if (SS_n) next_state = IDLE;
                else if (confirm_add) next_state = READ_DATA;
            end
            READ_DATA: begin
                if (SS_n) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Bit counter and shift register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_counter <= 0;
            rx_shift <= 0;
            confirm_add <= 0;
            rx_valid <= 0;
            ram_din <= 0;
            miso_reg <= 0;
        end else begin
            rx_valid <= 0;  // Default no valid data
            
            case (current_state)
                IDLE: begin
                    bit_counter <= 0;
                    miso_reg <= 0;
                end
                
                CHK_CMD: begin
                    bit_counter <= 0;
                end
                
                WRITE: begin
                    if (bit_counter < 10) begin
                        rx_shift <= {rx_shift[8:0], MOSI};
                        bit_counter <= bit_counter + 1;
                    end
                    
                    if (bit_counter == 9) begin
                        rx_valid <= 1;
                        ram_din <= {rx_shift[8:0], MOSI};  // Capture 10th bit
                    end
                end
                
                READ_ADD: begin
                    if (bit_counter < 10) begin
                        rx_shift <= {rx_shift[8:0], MOSI};
                        bit_counter <= bit_counter + 1;
                    end
                    
                    if (bit_counter == 9) begin
                        rx_valid <= 1;
                        ram_din <= {rx_shift[8:0], MOSI};  // Capture 10th bit
                        confirm_add <= 1;
                    end
                end
                
                READ_DATA: begin
                    if (!ram_tx_valid) begin
                        if (bit_counter < 10) begin
                            rx_shift <= {rx_shift[8:0], MOSI};
                            bit_counter <= bit_counter + 1;
                        end
                        
                        if (bit_counter == 9) begin
                            rx_valid <= 1;
                            ram_din <= {rx_shift[8:0], MOSI};
                            confirm_add <= 0;
                        end
                    end else begin
                        // Transmit data
                        if (bit_counter >= 3 && bit_counter <= 10) begin
                            miso_reg <= ram_dout[10 - bit_counter];
                        end
                        
                        if (bit_counter > 3) begin
                            bit_counter <= bit_counter - 1;
                        end
                    end
                end
            endcase
            
            // Reset bit counter on SS_n edge
            if (last_ssn && !SS_n) begin
                bit_counter <= 0;
            end
        end
    end

    // RAM model
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ram_dout <= 0;
            ram_tx_valid <= 0;
            temp_rd <= 0;
            temp_wr <= 0;
        end else begin
            ram_tx_valid <= 0;  // Default no valid output
            
            if (rx_valid) begin
                case (ram_din[9:8])
                    2'b00: begin  // Set write address
                        temp_wr <= ram_din[7:0];
                    end
                    2'b01: begin  // Write data
                        mem[temp_wr] <= ram_din[7:0];
                    end
                    2'b10: begin  // Set read address
                        temp_rd <= ram_din[7:0];
                    end
                    2'b11: begin  // Read data
                        ram_dout <= mem[temp_rd];
                        ram_tx_valid <= 1;
                    end
                endcase
            end
        end
    end

    // MISO output
    assign MISO = (current_state == READ_DATA && ram_tx_valid) ? miso_reg : 1'b0;

    // Debug signals (can be removed for synthesis)
    logic [7:0] debug_mem_read;
    assign debug_mem_read = mem[temp_rd];
    
endmodule