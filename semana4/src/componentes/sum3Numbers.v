module sum3Numbers(
    input [11:0] a,        // 12-bit input a
    input [11:0] b,        // 12-bit input b
    input [11:0] c,        // 12-bit input c
    output [12:0] result   // 13-bit output 
);

    assign result = a + b + c; // Sum of three 12-bit numbers

endmodule
