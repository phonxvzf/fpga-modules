`timescale 1ns / 1ns

module clock_div4(output reg clk_div = 0, input clk);

reg clock_div2 = 0;

always @(posedge clk)
begin
    clock_div2 = ~clock_div2; 
end

always @(posedge clock_div2)
begin
    clk_div = ~clk_div;
end

endmodule
