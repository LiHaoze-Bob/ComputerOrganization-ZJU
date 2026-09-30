module ALU(
    input  wire [31:0] A,
    input  wire [2:0]  ALU_operation,
    input  wire [31:0] B,
    output wire [31:0] res,
    output wire        zero
);
    wire [31:0] and_res, or_res, xor_res, nor_res, srl_res;
    wire [31:0] sub_mask, b_for_add;
    wire [32:0] add_s;

    and32_0 u_and(.A(A), .B(B), .res(and_res));
    or32_0  u_or (.A(A), .B(B), .res(or_res));
    xor32_0 u_xor(.A(A), .B(B), .res(xor_res));
    nor32_0 u_nor(.A(A), .B(B), .res(nor_res));
    srl32_0 u_srl(.A(A), .B(B), .res(srl_res));

    // 操作码最高位为 1 时，计算 A - B。
    SignalExt_32_0 u_ext(
        .S(ALU_operation[2]),
        .So(sub_mask)
    );
    xor32_0 u_invert_b(
        .A(sub_mask),
        .B(B),
        .res(b_for_add)
    );
    ADC32_0 u_add(
        .A(A),
        .B(b_for_add),
        .C0(ALU_operation[2]),
        .S(add_s)
    );

    mux8to1_32_0 u_mux(
        .s(ALU_operation),
        .I0(and_res),
        .I1(or_res),
        .I2(add_s[31:0]),
        .I3(xor_res),
        .I4(nor_res),
        .I5(srl_res),
        .I6(add_s[31:0]),
        .I7({31'b0, add_s[32]}),
        .o(res)
    );

    or_bit_32_0 u_zero(.A(res), .o(zero));
endmodule