`timescale 1ns / 1ps

module ALU_tb;
    reg  [31:0] A, B;
    reg  [2:0]  ALU_operation;
    wire [31:0] res;
    wire        zero;
    integer    errors;

    ALU dut(
        .A(A),
        .ALU_operation(ALU_operation),
        .B(B),
        .res(res),
        .zero(zero)
    );

    task check;
        input [31:0] a_value, b_value;
        input [2:0]  operation;
        input [31:0] expected;
        begin
            A = a_value;
            B = b_value;
            ALU_operation = operation;
            #10;
            if (res !== expected || zero !== (expected == 32'b0)) begin
                $display("FAIL op=%b A=%h B=%h res=%h zero=%b expected=%h",
                         operation, A, B, res, zero, expected);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        errors = 0;

        check(32'hA5A5A5A5, 32'h5A5A5A5A, 3'b000, 32'h00000000); // AND
        check(32'hA5A5A5A5, 32'h5A5A5A5A, 3'b001, 32'hFFFFFFFF); // OR
        check(32'hA5A5A5A5, 32'h5A5A5A5A, 3'b010, 32'hFFFFFFFF); // ADD
        check(32'hA5A5A5A5, 32'h5A5A5A5A, 3'b011, 32'hFFFFFFFF); // XOR
        check(32'hA5A5A5A5, 32'h5A5A5A5A, 3'b100, 32'h00000000); // NOR
        check(32'hA5A5A5A5, 32'h5A5A5A5A, 3'b101, 32'h2D2D2D2D); // B >> 1
        check(32'hA5A5A5A5, 32'h5A5A5A5A, 3'b110, 32'h4B4B4B4B); // SUB
        check(32'hA5A5A5A5, 32'h5A5A5A5A, 3'b111, 32'h00000000); // unsigned SLT

        check(32'h00000000, 32'h00000001, 3'b111, 32'h00000001);
        check(32'h80000000, 32'h00000001, 3'b111, 32'h00000000);
        check(32'h01234567, 32'h01234567, 3'b110, 32'h00000000);

        if (errors == 0)
            $display("ALU PASS");
        else
            $display("ALU FAIL: %0d cases", errors);
        $finish;
    end
endmodule