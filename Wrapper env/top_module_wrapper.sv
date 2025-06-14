module top_module_wrapper();
`include "uvm_macros.svh"
import uvm_pkg::*;
import test_wrapper::*;
    bit clk;
    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    

    
initial begin
        uvm_config_db#(bit)::set(null, "uvm_test_top", "clk", clk);
        run_test("test_wrapper");
    
end    




endmodule