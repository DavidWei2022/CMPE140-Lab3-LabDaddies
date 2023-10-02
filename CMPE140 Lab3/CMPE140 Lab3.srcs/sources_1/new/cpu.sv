`timescale 1ns / 1ps
module cpu(input rst_n, input clk,input [31:0] imem_insn, inout [31:0] dmem_data, 
    output [31:0] imem_addr,output [31:0] dmem_addr,output dmem_wen);
    reg [31:0] data[31:0];
    reg pc =0;
    //Fetch File
     //Fetch File
    reg [7:0] mem [255:0];
    integer count =0;
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
    reg [7:0] opcode[6:0];
    reg [7:0] imm[11:0];
    reg [7:0] funct3[2:0];
    reg [7:0] rd[4:0];
    reg [7:0] rs1[4:0];
    reg [7:0] ALU_Control[5:0];
    
    always @ (posedge clk)
    begin
   
    for(integer i=0; i<7;i=i+1)begin
        opcode[i]=data[i][6:0];
        
        rd[i]=data[i][11:7];
        funct3[i]=data[i][14:12];
    
        rs1[i]=data[i][19:15]; 
        imm[i]=data[i][31:20];
        end
    end
    
    
    always @ (*)
    begin
    for(int i =0;i<7;i=i+1)
        begin
            case(opcode[i])
               
                7'b0010011: begin //I-type
                    $display("the opcode is %b",opcode[i]);
                  if (funct3[i] == 3'b000) begin
                    ALU_Control[i] = 6'b000000; //addi 
                    $display("the ALU control is : %b\n",ALU_Control[i]);
                    end
                  
                    end
            endcase
        end
    end
    //execute    
    always @ (*)
    begin
        integer ii =0;
//    for(int i =0;i<7;i=i+1)begin
//        while(ii<7)begin
       rd[0] = rs1[0]+imm[0];
       $display("rd is %b", rd[0]);
       $display("count is %d",count);
       count = count+1;
//       ii = ii+1;
//       end
    end
    
    always @ (posedge clk)
    begin

       for(integer i=0; i<7;i=i+1)begin
        rd[i]=data[i][11:7];
        rs1[i]=data[i][19:15]; 
        imm[i]=data[i][31:20];
        end
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