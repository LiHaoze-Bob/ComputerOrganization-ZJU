module or_bit_32(
    input  wire [31:0] A,
    output wire        o
);
    assign o = (A == 32'b0);
endmodule
