`timescale 10ns/1ns

module seq(
    input clk,
    input reset,
    input in,
    output out
);
    parameter [2:0] S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011,
                    S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;

    reg [2:0] curr_state;
    reg [2:0] next_state;

    always @(posedge clk or negedge reset) begin
        if (!reset)
            curr_state <= S0;
        else
            curr_state <= next_state;
    end

    always @(*) begin
        case (curr_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S3 : S4;
            S4: next_state = in ? S1 : S5;
            S5: next_state = in ? S6 : S0;
            S6: next_state = in ? S2 : S7;
            S7: next_state = in ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    assign out = (curr_state == S7) ? 1'b1 : 1'b0;
endmodule