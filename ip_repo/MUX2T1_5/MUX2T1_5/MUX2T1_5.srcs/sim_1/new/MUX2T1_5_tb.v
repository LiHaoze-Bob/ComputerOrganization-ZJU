`timescale 1ns / 1ps

module MUX2T1_5_tb;

reg  [4:0] I0;
reg  [4:0] I1;
reg        s;
wire [4:0] o;

MUX2T1_5 uut (
    .I0(I0),
    .I1(I1),
    .s(s),
    .o(o)
);

initial begin
    I0 = 5'b00101;
    I1 = 5'b01010;

    s = 0;
    #50;

    s = 1;
    #50;

    $finish;
end

endmodule