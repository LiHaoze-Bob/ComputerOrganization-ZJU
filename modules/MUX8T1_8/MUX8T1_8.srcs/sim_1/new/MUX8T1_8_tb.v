`timescale 1ns / 1ps

module MUX8T1_8_tb;

reg  [7:0] I0;
reg  [7:0] I1;
reg  [7:0] I2;
reg  [7:0] I3;
reg  [7:0] I4;
reg  [7:0] I5;
reg  [7:0] I6;
reg  [7:0] I7;
reg  [2:0] s;
wire [7:0] o;

MUX8T1_8 dut (
    .I0(I0),
    .I1(I1),
    .I2(I2),
    .I3(I3),
    .I4(I4),
    .I5(I5),
    .I6(I6),
    .I7(I7),
    .s(s),
    .o(o)
);

task check;
    input [2:0] select;
    input [7:0] expected;
    begin
        s = select;
        #10;

        if (o !== expected)
            $display("ERROR: s=%b, o=%h, expected=%h",
                     s, o, expected);
        else
            $display("PASS:  s=%b, o=%h",
                     s, o);
    end
endtask

initial begin
    I0 = 8'h11;
    I1 = 8'h22;
    I2 = 8'h33;
    I3 = 8'h44;
    I4 = 8'h55;
    I5 = 8'h66;
    I6 = 8'h77;
    I7 = 8'h88;

    check(3'b000, I0);
    check(3'b001, I1);
    check(3'b010, I2);
    check(3'b011, I3);
    check(3'b100, I4);
    check(3'b101, I5);
    check(3'b110, I6);
    check(3'b111, I7);

    $display("MUX8T1_8 simulation finished");
    $finish;
end

endmodule