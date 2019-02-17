`timescale 1ns / 1ns
module d_flipflop(
    output reg q,
    input clock,
    input nreset,
    input d
    );
    
reg buffer;

always @(posedge clock)
begin
    buffer = d;
end

// Asynchronous reset (active low)
always @(buffer or nreset)
begin
   q = buffer & nreset; 
end
    
endmodule
