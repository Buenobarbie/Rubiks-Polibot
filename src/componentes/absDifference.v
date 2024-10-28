module absDifference #(parameter N = 5)
(
    input [WIDTH-1:0] a,     // Input a (unsigned)
    input [WIDTH-1:0] b,     // Input b (unsigned)
    output [WIDTH-1:0] result // Output: |a - b|
);

    assign result = (a > b) ? (a - b) : (b - a); // Calculate absolute difference

endmodule
