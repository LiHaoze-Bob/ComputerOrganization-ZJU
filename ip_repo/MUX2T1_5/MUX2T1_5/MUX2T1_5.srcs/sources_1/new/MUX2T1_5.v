`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/22/2026 02:46:11 PM
// Design Name: 
// Module Name: MUX2T1_5
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MUX2T1_5(
    input  wire [4:0] I0,
    input  wire [4:0] I1,
    input  wire       s,
    output wire [4:0] o
);

assign o = s ? I1 : I0;

endmodule


