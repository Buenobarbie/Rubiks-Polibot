module minIndex(
    input wire C0,    // Resultado da comparação entre R0 e R1
    input wire C1,    // Resultado da comparação entre R2 e R3
    input wire C2,    // Resultado da comparação entre R4 e R5
    input wire C3,    // Resultado da comparação entre min(R0, R1) e min(R2, R3)
    input wire C4,    // Resultado da comparação entre min(C3) e min(R4, R5)
    output wire [2:0] min_index
);

    wire B2, B1, B0;

    // B2: Determina se estamos no grupo {R4, R5} (C4 = 0)
    assign B2 = ~C4;

    // B1: Seleciona o subgrupo dentro do grupo maior
    assign B1 = (C4 & ~C3);

    // B0: Seleciona o índice dentro do subgrupo final
    assign B0 = (~C0 & C3 & C4) || (~C1 & ~C3 & C4) || (~C2 & ~C4);

    // Concatenação dos bits para gerar o índice final
    assign min_index = {B2, B1, B0};

endmodule
