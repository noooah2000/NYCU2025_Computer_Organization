// student ID: 314551161
`timescale 1ns/1ps

module MUX_2to1 #(
	parameter size = 32
)(
	input      [size-1:0] src1,
	input      [size-1:0] src2,
	input                 select,
	output reg [size-1:0] result
);

always @(*) begin
	if (select)
		result <= src2;
	else
		result <= src1;
end

endmodule
