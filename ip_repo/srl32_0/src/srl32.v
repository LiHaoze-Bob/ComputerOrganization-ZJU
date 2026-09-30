module srl32(
    input  wire [31:0] A,
    input  wire [31:0] B,
    output wire [31:0] res
);
    // 与课程提供的 ALU 示例一致：B 逻辑右移 1 位。
    assign res = B >> 1;
endmodule
