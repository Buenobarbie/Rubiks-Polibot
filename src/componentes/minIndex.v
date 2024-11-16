module MinIndex(
    input wire C1,    // Comparison result of R0 vs R1
    input wire C2,    // Comparison result of R2 vs R3
    input wire C3,    // Comparison result of R4 vs R5
    input wire C4,    // Result of comparison between min(R0, R1) and min(R2, R3)
    input wire C5,    // Result of comparison between min(C4 result) and min(R4, R5)
    output wire [2:0] min_index
);

    wire B2, B1, B0;

    // B2 is simply equal to C5
    assign B2 = C5;

    // B1 is set by the condition: C4 AND NOT C5
    assign B1 = C4 & ~C5;

    // B0 is set by: NOT C5 AND (C1 AND NOT C4 OR C2 AND C4)
    assign B0 = ~C5 & ((C1 & ~C4) | (C2 & C4));

    // The output is the concatenation of B2, B1 and B0
    assign min_index = {B2, B1, B0};

endmodule
