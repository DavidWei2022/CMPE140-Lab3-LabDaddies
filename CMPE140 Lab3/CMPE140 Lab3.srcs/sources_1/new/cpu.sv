`timescale 1ms / 1ns
module cpu(input rst_n,input clk,output reg [31:0] imem_addr,input reg [31:0] imem_insn,
output reg [31:0] dmem_addr,inout [31:0] dmem_data, output reg dmem_wen);
    
    reg[15:0] clock_counter; //incrementing counter by 1 during each pipeline phase 
    reg [31:0]imem_addr_reg, imem_insn_reg, dmem_addr_reg, dmem_data_reg;
    
    integer file_1, file_2;//defining file integers for file data

    reg [6:0] opcode; //defining all parameters for I-type instructions
    reg [4:0] rd;
    reg [2:0] func3;
    reg [4:0] rs1;
    reg [11:0] immed;

    reg [4:0] rd_reg, rd_final; //defining registers to hold values along with hazard detection
    reg [4:0] rd_previous;
    integer stall;
    integer count;
    integer i;
    integer PC;
    reg [31:0] rd_write [31:0];
    integer addi;
    
    assign imem_addr = imem_addr_reg;
    initial begin//set the file to be empty
        file_1 = $fopen("fetched_PC.txt", "w");
        $fdisplay(" ");
        $fclose(file_1);
        file_2 = $fopen("CC.txt", "w");
        $fdisplay(" ");
        $fclose(file_2);
    end

    always @(posedge clk) begin 
        if(!rst_n) begin //reseting all declared variables to known value
             imem_addr_reg <= 32'b0;
             imem_insn_reg <= 32'b0;
             dmem_addr_reg <= 32'b0;
             dmem_wen <= 1'b0;
             opcode <= 7'b0;
             clock_counter <= 16'b0;
             func3 <= 3'b0;
             rs1 <= 5'b0;
             immed <= 12'b0;
             rd_reg <= 5'b0;
             rd_final <= 5'b0;
             stall = 0;
             count = 0;
             PC = 0;
             for(i=0;i<32;i++)
                rd_write[i]<=0;
             
        end
        else begin 
            
                if(stall != 1) begin //entering fetch phase of pipeline
                    clock_counter <= clock_counter + 1;
                    PC <= PC + 1;
                    $display("Clock counter is...%b", clock_counter);
                    imem_addr_reg <= imem_addr;
                    imem_insn_reg <= imem_insn;
                    file_1 = $fopen("fetched_PC.txt", "a");
                    $display("Address contents are...%b", imem_addr_reg);
                    $display("Instruction contents are...%b", imem_insn_reg);
                    imem_addr_reg <= imem_addr_reg + 4; //incrementing by 4 to reach next set of instructions

                    if(imem_insn_reg != 8'hxxxxxxxx) begin //if file can be read, display file contents
                        $fdisplay(file_1,"%h\n", imem_insn_reg);    
                    end 

                    file_2 = $fopen("CC.txt", "a"); 
                    $fdisplay(file_2,"Register number is...%h", rd);
                    $fdisplay(file_2,"Register contents are...%h\n", rd_reg);
                end
                else if (stall) begin
                    $display("Entering stall state.");
                end
         end
         end


            always @(posedge clk) begin
                if(stall != 1) begin //entering decode phase of pipeline
                     clock_counter <= clock_counter + 1;
                    // $display("Clock counter is...%b", clock_counter);
                    if(imem_insn_reg != 8'hxxxxxxxx) begin //handling I-type      
                        immed <= imem_insn_reg[31:20];
                        rs1 <= imem_insn_reg[19:15];
                        func3 <= imem_insn_reg[14:12];
                        rd <= imem_insn_reg[11:7]; 
                        opcode <= imem_insn_reg[6:0];
                        rd_previous <= rd;
                        rd_write[rd]<=rd;
                        rd_write[rs1]<=rs1;
                    end
                    $fdisplay(file_2,"Register number is...%h", rd);
                    $fdisplay(file_2,"Register contents are...%h\n", rd_reg);
//                   $display("rd: %b, rs1: %b, rd_previous: %b", rd, rs1, rd_previous); 
                end  
                else if (stall) begin
                     $display("Entering stall state.");
                end
                
                if(rd_previous == rs1) begin //handling hazards
                    stall <= 1;
                    count <= count + 1;
                    //$display("Stall value is...%d",clock_counter);
                 end 
                 else begin
                    stall <= 0;
                 end
                 if(count >=3)begin
                    stall<=0;
                  end
            end
        

            always @(posedge clk) begin
                if(stall != 1) begin //entering execute phase of pipeline
                    clock_counter <= clock_counter + 1;
                    //$display("Clock counter is...%b", clock_counter);
                    case (opcode[6:0])
                        7'b0010011 : begin //defining addi opcode
                            addi = 1'b1; 
                            if(rd_write[rd] === 32'bx) begin //if there exist no value
                            rd_write[rd]<={ {20{immed[11]}}, {immed[11:0]} } + rs1;
                            rd_reg<={ {20{immed[11]}}, {immed[11:0]} } + rs1;
                        end
                        else begin
                            rd_write[rd]<={ {20{immed[11]}}, {immed[11:0]} } + rd_write[rs1];
                            rd_reg<={ {20{immed[11]}}, {immed[11:0]} } + rd_write[rs1];
                        end
                            //rd_reg <= immed + rs1;
                            $display("rd_reg: %b", rd_reg);
                        end    
                        default: begin
                            addi = 1'b0;    
                        end     
                    endcase
                   $fdisplay(file_2,"Register number is...%h", rd);
                   $fdisplay(file_2,"Register contents are...%h\n", rd_reg);
                end
                else if (stall) begin
                     $display("Entering stall state.");
                end
                end
                
                
                always @(posedge clk) begin
                if(stall != 1) begin //entering mem access phase of pipeline
                     clock_counter <= clock_counter + 1;
                  //$display("Clock counter is...%b", clock_counter);
                  $fdisplay(file_2,"Register number is...%h", rd);
                  $fdisplay(file_2,"Register contents are...%h\n", rd_reg);
                  
                end
                else if (stall) begin
                    $display("Entering stall state.");
                end
                end
                
                
                always @(posedge clk) begin      
                if(stall != 1) begin //entering write back phase of pipeline
                    clock_counter <= clock_counter + 1;
                    //$display("Clock counter is...%b", clock_counter);
                    //rd_write[rd] <= rd_reg;
                    rd_final <= rd_reg;
                   $fdisplay(file_2,"Register number is...%h", rd);
                   $fdisplay(file_2,"Register contents are...%h\n", rd_reg);
                end
                else if (stall)begin
                    $display("Entering stall state.");    
                end

 

        $fclose(file_1);
        $fclose(file_2);
    end
endmodule