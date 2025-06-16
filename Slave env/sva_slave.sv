module sva_slave(
    input clk,
    input logic rst_n,
    input logic MOSI,
    input logic SS_n,
    input logic tx_valid,
    input logic [7:0] tx_data,
    input logic MISO,
    input logic rx_valid,
    input logic [9:0] rx_data


);
    property rst_n_assertion;
        @(posedge clk) (!rst_n) |=> (rx_valid == 0 && rx_data == 0 && MISO == 0)
    endproperty
   assert property (rst_n_assertion)
        else $error("rst_n assertion failed: rst_n is low while rx_valid, rx_data, and MISO are not zero");

    cover property (rst_n_assertion);  
endmodule