`timescale 1ns / 1ps
module cpu(input rst_n, input clk,input [31:0] imem_insn, inout [31:0] dmem_data, 
    output [31:0] imem_addr,output [31:0] dmem_addr,output dmem_wen);
    reg [31:0] data[31:0];
    
    //Fetch File
     //Fetch File
    reg [7:0] mem [255:0];
    initial
        begin
            $readmemb("addi_nohazard.dat", mem);
        end

    integer fd;
    integer j =0;
    initial
        begin

            fd = $fopen("addi_nohazard.dat", "r");
            if(fd)  $display("File successfully opened!");
            else    $display("File NOT successfully opened!");
        end

       

    initial
        begin
            for(integer i = 0; i < 28; i = i+1)
               begin
                $display("%b",mem[i]);
                if(i %4 ==0)
                begin
                 data[j] = {mem[i+3], mem[i+2], mem[i+1], mem[i]};
                 j = j+1;
                end
             end
        end
            
    initial
        begin
        for(integer i =0; i<j;i=i+1)
        $display("%b",data[i]);
        end
    
//    rom fetch(imem_insn, data);
    
    always @ (posedge clk)
    
//    $display ("a is %h", data);
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