`timescale 1ns / 1ns

module main(seg, an, dp, clk); 

output wire [6:0] seg;
output reg [3:0] an; // active low
output reg dp = 1; // active low
input wire clk;

wire [3:0] nan;
wire clk_div;
wire [9:0] path;
reg d;
reg [3:0] hex;

genvar i;
generate 
    for (i = 0; i < 9; i = i+1)
    begin: CLK_DIV4
        clock_div4 clone(path[i+1], path[i]);
    end
endgenerate

assign path[0] = clk;
assign clk_div = path[9];

shift_reg #(.WIDTH(4)) SHIFT_REG(nan, d, clk_div);
seven_segment SEG_CONV(seg, hex);

always @(nan)
begin
    an = ~nan;
end

always @(an)
begin
    case (an)
        4'b0111: hex = 4'b0001;
        4'b1011: hex = 4'b0010;
        4'b1101: hex = 4'b0011;
        4'b1110: hex = 4'b0100;
        default: hex = 4'b0000;
    endcase
end

always @(an)
begin
    d = nan[3];
end

endmodule
