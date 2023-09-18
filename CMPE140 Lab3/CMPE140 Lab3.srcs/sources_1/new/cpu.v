`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Michelle Fang, Matthew Malvini, Ajay Walia, David Wei 
// 
// Create Date: 09/18/2023 01:21:20 PM
// Module Name: cpu
// Project Name: Lab 3 Group Project
// Description: 
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
