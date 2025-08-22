// ID
module Hazard_Detection(
    memread,
    ifid_instr,
    idex_rt,
    branch,
    pc_write,
    ifid_write,
    ifid_flush,
    idex_flush,
    exmem_flush
);

input memread;        
input [31:0] ifid_instr;        
input [4:0] idex_rt;    
input [1:0] branch;       
output reg pc_write;
output reg ifid_write;
output reg ifid_flush;
output reg idex_flush;
output reg exmem_flush;

wire [4:0] ifid_rs = ifid_instr[25:21];
wire [4:0] ifid_rt = ifid_instr[20:16];

always @(*) begin
    pc_write = 1'b1;
    ifid_write = 1'b1;
    ifid_flush = 1'b0;
    idex_flush = 1'b0;
    exmem_flush = 1'b0;

    if (branch != 2'b0) begin
        ifid_flush = 1'b1;   
        idex_flush = 1'b1;   
        exmem_flush = 1'b1;   
    end

    else if (memread && (idex_rt != 5'd0) &&
                ((idex_rt == ifid_rs) || (idex_rt == ifid_rt))) begin
        pc_write = 1'b0;   
        ifid_write = 1'b0;   
        idex_flush = 1'b1;   
    end
end

endmodule