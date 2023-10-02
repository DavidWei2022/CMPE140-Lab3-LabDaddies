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
//                $display("%b",mem[i]);
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
    

   //Decode
    reg [6:0] opcode;
    reg [11:0] imm;
    reg [2:0] funct3;
    reg [4:0] rd;
    reg [4:0] rs1;
    reg [5:0] ALU_Control;
    
    always @ (posedge clk)
    begin
   
//    for(integer i=0; i<7;i=i+1)begin
        opcode=data[0][6:0];

        rd=data[0][11:7];
        funct3=data[0][14:12];
    
        rs1=data[0][19:15]; 
        imm=data[0][31:20];
//        end
    end
    
    
    always @ (*)
    begin
    case(opcode)
       
        7'b0010011: begin //I-type
          if (funct3 == 3'b000) begin
            ALU_Control = 6'b000000; //addi 
            $display("the ALU control is : %b\n",ALU_Control);
            end
           else
           begin
           end
            end
    endcase

    end
    //execute    
    always @ (*)

    begin
       rd = rs1+imm;
       $display("rd is %b", rd);
    end
    
    always @ (posedge clk)
    begin
        rd=data[0][11:7];    
        rs1=data[0][19:15]; 
        imm=data[0][31:20];
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