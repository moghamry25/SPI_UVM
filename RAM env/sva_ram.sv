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
    
    reset_assertion: assert property (rst_n_p) else $error("Assertion rst_n failed!");
     cover property (rst_n_p);

    property tx_vaildd;
        @(posedge clk) disable iff(!rst_n)(datain[9:8]==(2'b00 || 2'b01 || 2'b10) && rx_valid ) |=> (tx_valid == 0);
    endproperty
    
    tx_vaild_for_first_three_cases: assert property (tx_vaildd) else $error("Assertion tx_vaild_for_first_three_cases failed!");
     cover property (tx_vaildd);

    property tx_vaild_pp;
        @(posedge clk) disable iff(!rst_n) (datain[9:8]==(2'b11)&& rx_valid) |=> (tx_valid);
    endproperty
    
    tx_vaild_for_last_case: assert property (tx_vaild_pp) else $error("Assertion tx_vaild_pp failed!");
     cover property (tx_vaild_pp);


    
endmodule