`timescale 1ns / 1ps

module Regs_tb;

    reg         clk;
    reg         rst;
    reg  [4:0]  Rs1_addr;
    reg  [4:0]  Rs2_addr;
    reg  [4:0]  Wt_addr;
    reg  [31:0] Wt_data;
    reg         RegWrite;

    wire [31:0] Rs1_data;
    wire [31:0] Rs2_data;

    Regs uut (
        .clk      (clk),
        .rst      (rst),
        .Rs1_addr (Rs1_addr),
        .Rs2_addr (Rs2_addr),
        .Wt_addr  (Wt_addr),
        .Wt_data  (Wt_data),
        .RegWrite (RegWrite),
        .Rs1_data (Rs1_data),
        .Rs2_data (Rs2_data)
    );

    always #5 clk = ~clk;

    task write_reg;
        input [4:0]  addr;
        input [31:0] data;
        begin
            @(negedge clk);
            Wt_addr  = addr;
            Wt_data  = data;
            RegWrite = 1'b1;

            @(posedge clk);
            #1;
            RegWrite = 1'b0;
        end
    endtask

    task check_read;
        input [4:0]  addr1;
        input [31:0] expected1;
        input [4:0]  addr2;
        input [31:0] expected2;
        begin
            Rs1_addr = addr1;
            Rs2_addr = addr2;
            #1;

            if ((Rs1_data !== expected1) ||
                (Rs2_data !== expected2)) begin
                $display(
                    "ERROR: x%0d=%h, expected=%h; x%0d=%h, expected=%h",
                    addr1, Rs1_data, expected1,
                    addr2, Rs2_data, expected2
                );
            end
            else begin
                $display(
                    "PASS: x%0d=%h, x%0d=%h",
                    addr1, Rs1_data,
                    addr2, Rs2_data
                );
            end
        end
    endtask

    initial begin
        clk       = 1'b0;
        rst       = 1'b0;
        Rs1_addr  = 5'd0;
        Rs2_addr  = 5'd0;
        Wt_addr   = 5'd0;
        Wt_data   = 32'd0;
        RegWrite  = 1'b0;

        #2 rst = 1'b1;
        #8 rst = 1'b0;

        check_read(5'd5, 32'd0, 5'd10, 32'd0);

        write_reg(5'd5,  32'hA5A5_A5A5);
        write_reg(5'd10, 32'h5A5A_5A5A);


        check_read(
            5'd5,  32'hA5A5_A5A5,
            5'd10, 32'h5A5A_5A5A
        );


        write_reg(5'd0, 32'hFFFF_FFFF);
        check_read(
            5'd0, 32'h0000_0000,
            5'd5, 32'hA5A5_A5A5
        );


        @(negedge clk);
        Wt_addr  = 5'd5;
        Wt_data  = 32'h1234_5678;
        RegWrite = 1'b0;

        @(posedge clk);
        #1;
        check_read(
            5'd5,  32'hA5A5_A5A5,
            5'd10, 32'h5A5A_5A5A
        );

        $display("All Regfile tests finished.");
        $finish;
    end

endmodule