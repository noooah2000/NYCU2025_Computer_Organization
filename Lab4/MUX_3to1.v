// Student ID: 314551161
`timescale 1ns/1ps

module MUX_3to1 #(
    parameter size = 32
)(
    input  [size-1:0] src1,
    input  [size-1:0] src2,
    input  [size-1:0] src3,
    input  [1:0]      select,
    output reg [size-1:0] result
);

    always @(*) begin
        case (select)
            2'b00: result = src1;
            2'b01: result = src2;
            2'b10: result = src3;
            default: result = {size{1'b0}};
        endcase
    end

endmodule
