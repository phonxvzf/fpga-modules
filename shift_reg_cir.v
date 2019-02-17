`timescale 1ns / 1ns

module shift_reg_cir(string, clk);

output reg [3:0] string = 4'b1000;
input clk;

always @(posedge clk)
begin
    string[2] <= string[3];
    string[1] <= string[2];
    string[0] <= string[1];
    string[3] <= string[0];
end

endmodule
