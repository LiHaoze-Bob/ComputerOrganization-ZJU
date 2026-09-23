`timescale 1ns / 1ps

module MUX4T1_5_tb;

reg  [4:0] I0;
reg  [4:0] I1;
reg  [4:0] I2;
reg  [4:0] I3;
reg  [1:0] s;
wire [4:0] o;

MUX4T1_5 dut (
    .I0(I0),
    .I1(I1),
    .I2(I2),
    .I3(I3),
    .s(s),
    .o(o)
);

task check;
    input [1:0] select;
    input [4:0] expected;
    begin
        s = select;
        #10;

        if (o !== expected)
            $display("ERROR: s=%b, o=%b, expected=%b",
                     s, o, expected);
        else
            $display("PASS:  s=%b, o=%b",
                     s, o);
    end
endtask

initial begin
    I0 = 5'b00001;
    I1 = 5'b00010;
    I2 = 5'b00100;
    I3 = 5'b01000;

    check(2'b00, I0);
    check(2'b01, I1);
    check(2'b10, I2);
    check(2'b11, I3);

    $display("MUX4T1_5 simulation finished");
    $finish;
end

endmodule