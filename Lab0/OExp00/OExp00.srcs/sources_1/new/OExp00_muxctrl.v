module OExp00_muxctrl(
    input  wire [4:0] I0,
    input  wire [4:0] I1,
    input  wire [1:0] s,
    input  wire       s1,
    input  wire [2:0] s2,
    output wire [4:0] o_0
);

wire [4:0] mux2_0_o;
wire [4:0] mux2_1_o;
wire [7:0] mux8_o;

MUX2T1_5_0 u_mux2_0 (
    .I0(I0),
    .I1(I1),
    .s(s1),
    .o(mux2_0_o)
);

MUX2T1_5_0 u_mux2_1 (
    .I0(I0),
    .I1(I1),
    .s(1'b1),
    .o(mux2_1_o)
);

MUX8T1_8_0 u_mux8 (
    .I0({mux2_0_o[3:0], mux2_1_o[3:0]}),
    .I1({mux2_1_o[3:0], mux2_0_o[3:0]}),
    .I2(8'b00000001),
    .I3(8'b00000001),
    .I4(8'b00000001),
    .I5(8'b00000001),
    .I6(8'b00000001),
    .I7(8'b00000001),
    .s(s2),
    .o(mux8_o)
);

MUX4T1_5_0 u_mux4 (
    .I0({1'b0, mux8_o[3:0]}),
    .I1({mux2_1_o[0], mux2_0_o[3:0]}),
    .I2(5'b00001),
    .I3(5'b00000),
    .s(s),
    .o(o_0)
);

endmodule