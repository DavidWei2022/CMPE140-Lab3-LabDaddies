module cpu(
    input rst_n,
    input clk,
    output reg [31:0] imem_addr,
    input reg [31:0] imem_insn,
    output reg [31:0] dmem_addr,
    inout [31:0] dmem_data,
    output reg dmem_wen
    );
    //Clock Cycle Counter to your processor that starts after reset and then increments by 1 every clock cycle.
    reg[15:0] ccc;
    integer valid_fetch, valid_decode, valid_execute, valid_memAccess, valid_write; //validating next cycle
    reg [31:0]imem_addr_reg, imem_insn_reg, dmem_addr_reg, dmem_data_reg;
    integer fd, fd2;
    reg [6:0]opcode;
    reg [4:0]rd;
    reg [2:0]func3;
    reg [4:0] rs1;
    reg [11:0] immed;
    integer addi;
    reg [4:0] rd_reg,rd_final;
    reg [4:0] rd_prev;
//    integer stall;
    //file array: reg [31:0] file[6:0];
    integer valid;
    initial begin
        //fd = $fopen("PC.txt", "w");
        //fd2 = $fopen("Reg.txt", "w"); 
        //$system("PC.txt");
        //$system("Reg.txt");
    end
    assign imem_addr = imem_addr_reg;
    always @ (*) begin
        if(rd_prev == rs1) begin //check for hazards
//            stall=1;
//            $display("STALL,%i",valid_execute);
            //valid_execute<=valid_execute; //wait one more cc
        end
//        else
//            stall=0; 
    end
    always @(posedge clk) begin 
        if(!rst_n) begin //reseting 
             imem_addr_reg<=32'b0;
             imem_insn_reg<=32'b0;
             dmem_addr_reg<=32'b0;
             dmem_wen<=1'b0;
             opcode<=7'b0;
             //rd<=5'b0;
             func3<=3'b0;
             rs1<=5'b0;
             immed<=12'b0;
             rd_reg<=5'b0;
             rd_final<=5'b0;
             //rs1_next<=5'b0;
             valid<=0;
             valid_fetch<=0;
             valid_decode<=0;
             valid_execute<=0;
             valid_memAccess<=0;
             valid_write<=0;
//             stall=0;
             
        end
        else begin 
            //fetch
            ccc=ccc+1;
            //once out of reset, you drive imem_addr in every clock cycle
            valid_fetch<=1;
            if(valid_fetch ) begin//&& ~stall
                imem_addr_reg<=imem_addr;
                imem_insn_reg<=imem_insn;
                fd = $fopen("PC.txt", "a");
                $display("addrADDR= %b", imem_addr_reg);
                $display("addrINSN= %b, %i", imem_insn_reg,valid_fetch);
                //for now just add 4 in every clock cycle since there are no jumps or branches yet              
                if(valid_fetch!=1)//so don't skip first insn read from imem_addr = 32'b0
                    imem_addr_reg<=imem_addr_reg + 4; //add 4
                //PC->instruction mem, fetch instruction
                //print every PC being fetched in hexadecimal, 1 per line
                if(imem_insn_reg != 8'hxxxxxxxx) begin // print all fetched imem_insn that are not XXX
                    $fdisplay(fd,"%h\n", imem_insn_reg);    
                end 
                fd2 = $fopen("Reg.txt", "a"); 
                $fdisplay(fd2,"reg number: %b", rd);
                $fdisplay(fd2,"reg value: %b\n", rd_reg);
                valid_fetch<=valid_fetch+1;
                //valid_fetch<=valid;
                valid_decode<=valid_fetch;
            end
//            else
//                valid_fetch<=valid_fetch;
                /* stop fetch?
                if(imem_insn == 8'hxxxxxxxx) begin
                    valid_fetch<=0;
                end
                */

            //decode
            //For decode, you will use verilog case construct and bit select eg (hypothetical example assuming bits 3:0 of the instruction contain the opcode and we need to assert signals add/ sub / and etc for different values) 
            if(valid_decode ) begin //&& ~stall
                ccc=ccc+1;
                valid_fetch++;
                //sort into I format   
                if(imem_insn_reg != 8'hxxxxxxxx) begin      
                    immed<=imem_insn_reg[31:20];
                    rs1<=imem_insn_reg[19:15];
                    func3<=imem_insn_reg[14:12];
                    rd<=imem_insn_reg[11:7]; 

                    opcode<=imem_insn_reg[6:0];
                    rd_prev<=rd;
                end
                //$display("%b",rd);
                // second file for data, you must print in every CC, the register number and the value being
                // written for instructions that write to a register (either decimal or hexadecimal ok)
                $fdisplay(fd2,"reg number: %b", rd);
                $fdisplay(fd2,"reg value: %b\n", rd_reg);
                valid_execute<=valid_decode;
                $display("rd: %b, rs1: %b, rd_prev: %b", rd, rs1, rd_prev);
//                if(rd_prev == rs1) begin //check for hazards
//                        stall=1;
//                        $display("STALL,%d",valid_decode);
                  
                        
//                        //valid_fetch<=valid_fetch-1; //wait one more cc
//                end
//                else
//                        stall=0; 
                    
                //valid_decode<=0;
            end
//            else
//                valid_decode<=valid_decode;
            
//            if(rd_prev == rs1) begin //check for hazards
//                    stall=1;
//                    $display("STALL,%i",valid_decode);
//                    valid_fetch<=valid_fetch-1; //wait one more cc
//            end
//            else
//                    stall=0; 
            
            //execute  
            if(valid_execute ) begin //&& ~stall
                ccc=ccc+1;
                valid_fetch++;

                case (opcode[6:0]) // Note bit select syntax -- first 7 bits is opcode
                    7'b0010011 : begin
                        addi = 1'b1; // Assert add if IR[3:0] == 4'b0001
                        rd_reg<=immed+rs1;
                        $display("rd_reg: %b", rd_reg);
                        
                    end    
                    default: begin
                        addi = 1'b0;    
                    end     
                endcase
                $fdisplay(fd2,"reg number: %b", rd);
                $fdisplay(fd2,"reg value: %b\n", rd_reg);
                valid_memAccess<=valid_execute;
                //valid_execute<=0;
            end
//            else
//                valid_execute<=valid_execute;
            //don't need to do anything with dmem_addr, dmem_wen, and dmem_data they don't have data
            //mem access
            if(valid_memAccess ) begin  //&& ~stall
                ccc=ccc+1;
                valid_fetch++;
                dmem_addr_reg<=rd_reg;
                //dmem_data_reg<=dmem_data;
                //dmem_data_reg<={ALU_result, rd};
                $fdisplay(fd2,"reg number: %b", rd);
                $fdisplay(fd2,"reg value: %b\n", rd_reg);
                valid_write<=valid_memAccess;

                //valid_memAccess<=0;
            end
//            else
//                valid_memAccess<=valid_memAccess;    
                       
            //write back
            //dmem_wen<=valid_write;
            if(valid_write) begin // &&~stall
                ccc=ccc+1;
                valid_fetch++;
                $fdisplay(fd2,"reg number: %b", rd);
                $fdisplay(fd2,"reg value: %b\n", rd_reg);
                rd_final<=rd_reg;
                //valid_write<=0;
                //valid_fetch<=1;
            end
//            else
//                valid_write<=valid_write;
      end
      /*
      if have fclose then get a lot of errors: File/Multi-channel descriptor (-20000) passed to $fclose is not valid. Please compile the design with -debug for source location information
      because keep closing the file on every CLK posedge in the always block
      no need to even call $fclose because it will be closed when the simulation terminates
        ???-ignore errors because sometime show--left fclose alone and did not put $finish
      */
        $fclose(fd);
        $fclose(fd2);
    end
        
endmodule