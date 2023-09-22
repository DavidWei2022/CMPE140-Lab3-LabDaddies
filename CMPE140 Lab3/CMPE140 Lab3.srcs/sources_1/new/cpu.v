`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Michelle Fang, Matthew Malvini, Ajay Walia, David Wei 
// 
// Create Date: 09/18/2023 01:21:20 PM
// Module Name: cpu
// Project Name: Lab 3 Group Project
// Description: 
// Revision:This is our project
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu(input rst_n, input clk,input [31:0] imem_insn, inout [31:0] dmem_data, 
    output [31:0] imem_addr,output [31:0] dmem_addr,output dmem_wen);
  

 //Fetch File
    reg [7:0] mem [255:0];
    initial
        begin
            $readmemb("addi_nohazard.dat", mem);

        end

    integer fd;
    initial
        begin

            fd = $fopen("addi_nohazard.dat", "r");


            if(fd)  $display("File successfully opened!");
            else    $display("File NOT successfully opened!");
        end

    initial
        begin
            for(integer i = 0; i < 28; i = i+1)
                $display("%b",mem[i]);
        end


    
    always @ (posedge clk)
    begin
    end
    
    //Decode
    always @ (*)
    begin
    end
    
    always @ (posedge clk)
    begin
    end
    
    //Execute
    always @ (*)
    begin
    end
    
    always @ (posedge clk)
    begin
    end
    
    //Memory access
    always @ (*)
    begin
    end
    
    always @ (posedge clk)
    begin
    end
    
    //Write back
    always @ (*)
    begin
    end
    
    always @ (posedge clk)
    begin
    end
endmodule
