`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2023 01:21:20 PM
// Design Name: 
// Module Name: cpu
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


module cpu(
    input rst_n,
    input clk,
    input [31:0] imem_insn, 
    inout [31:0] dmem_data, 
    output [31:0] imem_addr,
    output [31:0] dmem_addr,
    output dmem_wen
    );
endmodule
