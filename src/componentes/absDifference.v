module absDifference #(parameter N = 5)
(
    input [N-1:0] a,     // Input a (unsigned)
    input [N-1:0] b,     // Input b (unsigned)
    output [N-1:0] result // Output: |a - b|
);

    assign result = (a > b) ? (a - b) : (b - a); // Calculate absolute difference

endmodule
