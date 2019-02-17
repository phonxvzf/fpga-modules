`timescale 1ns / 1ns

module debouncer(output sync, input signal, input clk);

wire q1, q2;

assign sync = q1 & q2;

d_flipflop D1(q1, clk, 1'b1, signal);
d_flipflop D2(q2, clk, 1'b1, q1);

endmodule
