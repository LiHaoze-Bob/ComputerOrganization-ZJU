module ADC32(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        C0,
    output wire [32:0] S
);
    // 减法时由 ALU 在输入前按 C0 取反 B；第 33 位供无符号比较使用。
    assign S = {1'b0, A} + {C0, B} + C0;
endmodule
