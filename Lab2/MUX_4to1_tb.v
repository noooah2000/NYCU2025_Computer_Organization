// File: tb_MUX_4to1.v
`timescale 1ns/1ps

module tb_MUX_4to1;

  // Inputs
  reg src1;
  reg src2;
  reg src3;
  reg src4;
  reg [1:0] select;

  // Output
  wire result;

  // Instantiate the Unit Under Test (UUT)
  MUX_4to1 uut (
    .src1(src1),
    .src2(src2),
    .src3(src3),
    .src4(src4),
    .select(select),
    .result(result)
  );

  initial begin
    $display("Time\tSelect\tSrc1 Src2 Src3 Src4\tResult");

    // Test Case 1: select = 00
    src1 = 1; src2 = 0; src3 = 0; src4 = 0; select = 2'b00;
    #10 $display("%0t\t%b\t  %b    %b    %b    %b\t  %b", $time, select, src1, src2, src3, src4, result);

    // Test Case 2: select = 01
    src1 = 0; src2 = 1; src3 = 0; src4 = 0; select = 2'b01;
    #10 $display("%0t\t%b\t  %b    %b    %b    %b\t  %b", $time, select, src1, src2, src3, src4, result);

    // Test Case 3: select = 10
    src1 = 0; src2 = 0; src3 = 1; src4 = 0; select = 2'b10;
    #10 $display("%0t\t%b\t  %b    %b    %b    %b\t  %b", $time, select, src1, src2, src3, src4, result);

    // Test Case 4: select = 11
    src1 = 0; src2 = 0; src3 = 0; src4 = 1; select = 2'b11;
    #10 $display("%0t\t%b\t  %b    %b    %b    %b\t  %b", $time, select, src1, src2, src3, src4, result);

    // Random Test
    src1 = 1; src2 = 1; src3 = 0; src4 = 0; select = 2'b00;
    #10 $display("%0t\t%b\t  %b    %b    %b    %b\t  %b", $time, select, src1, src2, src3, src4, result);

    src1 = 1; src2 = 0; src3 = 0; src4 = 1; select = 2'b10;
    #10 $display("%0t\t%b\t  %b    %b    %b    %b\t  %b", $time, select, src1, src2, src3, src4, result);

    $finish;
  end

endmodule