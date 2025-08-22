// ID
module Forwarding_Unit(
    regwrite_mem,
    regwrite_wb,
    idex_rs,
    idex_rt,
    exmem_rd,
    memwb_rd,
    forwarda,
    forwardb
);

input regwrite_mem;
input regwrite_wb;
input [5-1:0] idex_rs;
input [5-1:0] idex_rt;
input [5-1:0] exmem_rd;
input [5-1:0] memwb_rd;
output reg [2-1:0] forwarda;
output reg [2-1:0] forwardb;


always @(*) begin
    forwarda = 2'b00;
    forwardb = 2'b00;
    // A (rs)
    if (regwrite_mem && (exmem_rd != 5'd0) && (exmem_rd == idex_rs))
        forwarda = 2'b01;  // EX/MEM
    else if (regwrite_wb && (memwb_rd != 5'd0) && (memwb_rd == idex_rs))
        forwarda = 2'b10;  // MEM/WB
    // B (rt)
    if (regwrite_mem && (exmem_rd != 5'd0) && (exmem_rd == idex_rt))
        forwardb = 2'b01;  // EX/MEM
    else if (regwrite_wb && (memwb_rd != 5'd0) && (memwb_rd == idex_rt))
        forwardb = 2'b10;  // MEM/WB
end


endmodule