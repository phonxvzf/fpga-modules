`timescale 1ns / 1ns

// Moore machine implementation of a single pulser
module single_pulser(pulse, signal, clk);

output reg pulse;
input wire signal;
input wire clk;

reg [1:0] state = 2'b00;

always @(posedge clk)
begin
    case (state)
        2'b00:
        begin
            if (signal) state = 2'b01;
        end
        2'b01:
        begin
            if (signal) state = 2'b10;
            else state = 2'b00;
        end
        2'b10:
        begin
            if (~signal) state = 2'b00;
        end
    endcase
end

always @(state)
begin
    case (state)
        2'b00: pulse = 0;
        2'b01: pulse = 1;
        2'b10: pulse = 0;
    endcase
end

endmodule
