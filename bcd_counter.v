`timescale 1ns / 1ns

module bcd_counter(value, cout, bout, up, down, set9, set0, clk);

output wire [3:0] value;
output wire cout, bout;
input wire up, down;
input wire set9, set0;
input wire clk;

reg [3:0] state = 4'b0000;

assign value = state;
assign cout = up & (state[3] & state[0] & ~(state[2] | state[1]));
assign bout = down & ~(state[3] | state[2] | state[1] | state[0]);

always @(posedge clk)
begin
    if (set0) state = 4'h0;
    else if (set9) state = 4'h9;
    else
    begin
        case (state)
            4'h0:
            begin
                if (down)
                begin
                    state = 4'h9;
                end
                else if (up)
                begin
                    state = 4'h1;
                end
            end
            4'h9:
            begin
                if (up)
                begin
                    state = 4'h0;
                end
                else if (down)
                begin
                    state = 4'h8;
                end
            end
            default:
            begin
                if (up) state = state + 1;
                else if (down) state = state - 1;
            end
        endcase
    end
end

endmodule
