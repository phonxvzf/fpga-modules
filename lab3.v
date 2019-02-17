`timescale 1ns / 1ns

//module main(seg, an, dp, sw, btnC, btnU, clk);
module main(seg, an, dp, sw, btnC, btnU, clk, value3, value2, value1, value0);

parameter DEBOUNCE_COUNTER_BITS = 23;

output wire [6:0] seg;
output reg [3:0] an; // active low
output reg dp = 1; // active low
input wire btnC, btnU;
input wire [7:0] sw;
input wire clk;

wire [3:0] nan;
wire clk_div;
wire [9:0] path;
wire [3:0] up, down;
wire [3:0] cout, bout;
wire [7:0] sw_s, sw_p, sw_db;
output wire [3:0] value3, value2, value1, value0;
//wire [3:0] value3, value2, value1, value0;
wire btnC_s, btnC_p, btnC_db;
wire btnU_s, btnU_p, btnU_db;
wire check9xxx, check99xx, check999x, check9999;
wire check0xxx, check00xx, check000x, check0000;
reg d;
reg [3:0] hex;

genvar i;
generate 
    for (i = 0; i < 9; i = i+1)
    begin: CLK_DIV4
        clock_div4 clone(path[i+1], path[i]);
    end
endgenerate

generate
    for (i = 0; i < 8; i = i+1)
    begin: PULSER
        single_pulser clone(sw_p[i], sw_s[i], clk_div);
    end
endgenerate

//generate
//    for (i = 0; i < 8; i = i+1)
//    begin: DEBOUNCER
//        debouncer #(.NBITS(DEBOUNCE_COUNTER_BITS)) clone(sw_db[i], sw[i], clk);
//    end
//endgenerate

assign path[0] = clk;
assign clk_div = path[9];

//debouncer #(.NBITS(DEBOUNCE_COUNTER_BITS)) BTN_DEBOUNCER(btnC_db, btnC, clk);
synchronizer #(.WIDTH(8)) SYNCHRONIZER(sw_s, sw, clk);
synchronizer #(.WIDTH(1)) BTN_SYNCHRONIZER(btnC_s, btnC, clk);
synchronizer #(.WIDTH(1)) BTNU_SYNCHRONIZER(btnU_s, btnU, clk);
single_pulser BTN_PULSER(btnC_p, btnC_s, clk_div);
single_pulser BTNU_PULSER(btnU_p, btnU_s, clk_div);

shift_reg #(.WIDTH(4)) SHIFT_REG(nan, d, clk_div);
seven_segment SEG_CONV(seg, hex);

bcd_counter BCD_COUNTER3(value3, cout[3], bout[3], up[3], down[3], btnU_p, btnC_p, clk_div);
bcd_counter BCD_COUNTER2(value2, cout[2], bout[2], up[2], down[2], btnU_p, btnC_p, clk_div);
bcd_counter BCD_COUNTER1(value1, cout[1], bout[1], up[1], down[1], btnU_p, btnC_p, clk_div);
bcd_counter BCD_COUNTER0(value0, cout[0], bout[0], up[0], down[0], btnU_p, btnC_p, clk_div);

assign check9xxx = (value3 == 9);
assign check99xx = check9xxx & (value2 == 9);
assign check999x = check99xx & (value1 == 9);
assign check9999 = check999x & (value0 == 9);
assign check0xxx = value3 == 0;
assign check00xx = check0xxx & value2 == 0;
assign check000x = check00xx & value1 == 0;
assign check0000 = check000x & value0 == 0;
assign up[3] = (sw_p[7] | cout[2]) & ~check9xxx;
assign up[2] = (sw_p[5] | cout[1]) & ~check99xx;
assign up[1] = (sw_p[3] | cout[0]) & ~check999x;
assign up[0] = sw_p[1] & ~check9999;
assign down[3] = (sw_p[6] | bout[2]) & ~check0xxx;
assign down[2] = (sw_p[4] | bout[1]) & ~check00xx;
assign down[1] = (sw_p[2] | bout[0]) & ~check000x;
assign down[0] = sw_p[0] & ~check0000;

always @(nan)
begin
    an = ~nan;
end

always @(an)
begin
    case (an)
        4'b0111: hex = value3;
        4'b1011: hex = value2;
        4'b1101: hex = value1;
        4'b1110: hex = value0;
        default: hex = 4'b0000;
    endcase
end

always @(an)
begin
    d = nan[3];
end

endmodule
