`timescale 1ns / 1ns

module synchronizer(sync, signal, clk);

parameter WIDTH = 1;

output reg [WIDTH-1:0] sync;
input wire [WIDTH-1:0] signal;
input wire clk;

reg [WIDTH-1:0] d;

always @(posedge clk)
begin
    d = signal;
end

always @(posedge clk)
begin
    sync = d;
end

endmodule
