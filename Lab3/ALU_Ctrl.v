// student ID:314551161
module ALU_Ctrl(
        funct_i,
        ALUOp_i,
        ALUCtrl_o
        );
          
// I/O ports 
input      [6-1:0] funct_i;
input      [2-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;  
     
// Internal Signals
reg [4-1:0] result;

// Main function
always @(*) begin
        if (ALUOp_i[1] == 1'b1) begin
                case (funct_i)
                        6'b100011: result = 4'b0010; //add
                        6'b100001: result = 4'b0110; //sub
                        6'b100110: result = 4'b0001; //and
                        6'b100101: result = 4'b0000; //or
                        6'b101011: result = 4'b1101; //nor
                        6'b101000: result = 4'b0111; //slt
                        6'b000010: result = 4'b1000; //sll
                        6'b000100: result = 4'b1001; //srl
                        6'b000110: result = 4'b1010; //sllv
                        6'b001000: result = 4'b1011; //srlv
                        6'b001100: result = 4'b1111; //jr
                        default: result = 4'b0000;
                endcase
        end else begin
                case (ALUOp_i[0])
                        1'b0: result = 4'b0010;
                        1'b1: result = 4'b0110;
                endcase
        end
end  

assign ALUCtrl_o = result;

endmodule