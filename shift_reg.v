`timescale 1ns / 1ns

module shift_reg(string, d, clk);

parameter WIDTH = 4;

output reg [WIDTH-1:0] string = {1'b1,{WIDTH-1{1'b0}}};
input wire d;
input wire clk;

always @(posedge clk)
begin
    string[0] <= d;
    string[WIDTH-1:1] <= string[WIDTH-2:0];
end
    
endmodule
