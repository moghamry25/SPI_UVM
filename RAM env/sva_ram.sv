module sva_ram(
    input logic clk,
    input logic rst_n,
    input logic rx_valid,
    input logic tx_valid,
    input logic [9:0] datain,
    input logic [7:0] dout
);

    
    
    property rst_n_p;
        @(posedge clk) (!rst_n) |=> (tx_valid == 0 && dout == 0);
    endproperty
    
    label: assert property (rst_n_p) else $error("Assertion rst_n failed!");
     cover property (rst_n_p);

    
endmodule