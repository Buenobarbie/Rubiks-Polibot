module identifica_cores_fd
(
    input wire             clock,
    input wire             reset,
    input wire [15:0]      pixel,
    input wire             zera_linha_pixel,
    input wire             zera_coluna_pixel,
    input wire             zera_cor,
    input wire             we_dist,
    input wire             conta_coluna_pixel,
    input wire             conta_linha_pixel,
    input wire             conta_cor,
    output wire [1:0]           linha_pixel_addr,
    output wire [1:0]          coluna_pixel_addr,
    output wire                fim_linha_pixel,
    output wire                fim_coluna_pixel,
    output wire [2:0] cor_final
);

    wire [2:0] cor_addr;
    wire [15:0] cor;
    wire [5:0] pixel_R;
    wire [5:0] pixel_G;
    wire [5:0] pixel_B;
    wire [5:0] cor_R;
    wire [5:0] cor_G;
    wire [5:0] cor_B;
    wire [5:0] diff_R;
    wire [5:0] diff_G;
    wire [5:0] diff_B;
    wire [11:0] sq_R;
    wire [11:0] sq_G;
    wire [11:0] sq_B;
    wire [12:0] soma_quadrados;
    wire [12:0] q0;
    wire [12:0] q1;
    wire [12:0] q2;
    wire [12:0] q3;
    wire [12:0] q4;
    wire [12:0] q5;
    wire c0;
    wire c1;
    wire c2;
    wire c3;
    wire c4;


    // Contador de linhas da memoria de pixels
    contador_m #(
        .M(3), 
        .N(2)
    ) contador_linha_pixel (
        .clock    (clock         ),
        .zera_as  (reset   ),
        .zera_s   (zera_linha_pixel   ),
        .conta    (conta_linha_pixel   ),
        .Q        (linha_pixel_addr    ),
        .fim      ( fim_linha_pixel    ),
        .meio     (    )
    );

    // Contador de colunas dos pixels lidos
    contador_m #(
        .M(3), 
        .N(2)
    ) contador_coluna_pixel (
        .clock    (clock         ),
        .zera_as  (reset  ),
        .zera_s   (zera_coluna_pixel  ),
        .conta    (conta_coluna_pixel  ),
        .Q        (coluna_pixel_addr   ),
        .fim      (  fim_coluna_pixel  ),
        .meio     (    )
    );

    // Contador de cores
    contador_m #(
        .M(6), 
        .N(3)
    ) contador_cor (
        .clock    (clock         ),
        .zera_as  (reset     ),
        .zera_s   (zera_cor     ),
        .conta    (conta_cor     ),
        .Q        (cor_addr          ),
        .fim      (    ),
        .meio     (    )
    );

    // Rom de cores
    rom_cores rom_cores (
        .clk (clock),
        .clear (reset),
        .addr (cor_addr),
        .q (cor)
    );

    assign pixel_R = pixel[15:11];
    assign pixel_G = pixel[10:5];
    assign pixel_B = pixel[4:0];

    assign cor_R = cor[15:11];
    assign cor_G = cor[10:5];
    assign cor_B = cor[4:0];

    // Red
    absDifference #(
        .N(6)
    ) abs_diff_R (
        .a (pixel_R),
        .b (cor_R),
        .result (diff_R)
    );

    // Green
    absDifference #(
        .N(6)
    ) abs_diff_G (
        .a (pixel_G),
        .b (cor_G),
        .result (diff_G)
    );

    // Blue
    absDifference #(
        .N(6)
    ) abs_diff_B (
        .a (pixel_B),
        .b (cor_B),
        .result (diff_B)
    );

    // Rom de quadrados
    rom_quadrados rom (
        .addr1 (diff_R),
        .addr2 (diff_G),
        .addr3 (diff_B),
        .data1 (sq_R),
        .data2 (sq_G),
        .data3 (sq_B)
    );

    // Somar quadrados
    sum3Numbers sum3 (
        .a (sq_R),
        .b (sq_G),
        .c (sq_B),
        .result (soma_quadrados)
    );

    // Ram dist
    ram_dist ram_dist (
        .clk (clock),
        .clear (reset),
        .we (we_dist),
        .data (soma_quadrados),
        .addr (cor_addr),
        .q0 (q0),
        .q1 (q1),
        .q2 (q2),
        .q3 (q3),
        .q4 (q4),
        .q5 (q5)
    );

    assign c0 = q0 > q1;
    assign c1 = q2 > q3;
    assign c2 = q4 > q5;

    assign c3 = c0 > c1;
    assign c4 = c2 > c3;

    minIndex minIndex (
        .C1 (c0),
        .C2 (c1),
        .C3 (c2),
        .C4 (c3),
        .C5 (c4),
        .min_index (cor_final)
    );


endmodule