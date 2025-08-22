// File: tb_MUX_2to1.v
`timescale 1ns/1ps

module tb_MUX_2to1;

  // Inputs
  reg src1;
  reg src2;
  reg select;

  // Output
  wire result;

  // Instantiate the Unit Under Test (UUT)
  MUX_2to1 uut (
    .src1(src1),
    .src2(src2),
    .select(select),
    .result(result)
  );

  initial begin
    $display("Time\tSelect\tSrc1 Src2\tResult");

    // Test Case 1: select = 0 => expect result = src1
    src1 = 0; src2 = 1; select = 0;
    #10 $display("%0t\t%b\t  %b    %b\t  %b", $time, select, src1, src2, result);

    // Test Case 2: select = 1 => expect result = src2
    src1 = 0; src2 = 1; select = 1;
    #10 $display("%0t\t%b\t  %b    %b\t  %b", $time, select, src1, src2, result);

    // Test Case 3: select = 0 => result = src1 = 1
    src1 = 1; src2 = 0; select = 0;
    #10 $display("%0t\t%b\t  %b    %b\t  %b", $time, select, src1, src2, result);

    // Test Case 4: select = 1 => result = src2 = 0
    src1 = 1; src2 = 0; select = 1;
    #10 $display("%0t\t%b\t  %b    %b\t  %b", $time, select, src1, src2, result);

    // Additional Random
    src1 = 1; src2 = 1; select = 0;
    #10 $display("%0t\t%b\t  %b    %b\t  %b", $time, select, src1, src2, result);

    src1 = 0; src2 = 0; select = 1;
    #10 $display("%0t\t%b\t  %b    %b\t  %b", $time, select, src1, src2, result);

    $finish;
  end

endmodule