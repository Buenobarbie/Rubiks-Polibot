module rubiks_polibot_fd(
    input  clock,
    input  reset,
    input  iniciar,
    input  zera_face,
    input  zera_movimento,
    input  captura_imagem,
    input  identificar_cores,
    input  enviar_cores,
    input  aciona_movimento,
    input  conta_movimento,
    input  conta_face,
    input  pronto,
    input rx_serial,
    output imagem_recebida,
    output cores_identificadas,
    output cores_transmitidas,
    output fim_face,
    output fim_movimento,
    output movimento_par,
    output meio_face,
    output movimentos_recebidos,
    output fim_rom

);

wire [6:0] s_db_estado_imagem;
wire [1:0] s_linha_face;
wire [1:0] s_coluna_face;
wire [15:0] s_pixel_face;
wire [15:0] s_pixel;
wire s_we_byte_face;
wire [1:0] s_linha_cor;
wire [1:0] s_coluna_cor;
wire [1:0] ram_pixels_addr1;
wire [1:0] ram_pixels_addr2;

wire s_we_cor;
wire s_cor_final;
wire s_cor;

wire [8:0] s_movimento;


// Saidas seriais
wire s_saida_serial_imagem;

// Contador de faces
contador_m #(
    .M(6), 
    .N(3)
) contador_face (
    .clock    (clock         ),
    .zera_as  (reset   ),
    .zera_s   (zera_face   ),
    .conta    (conta_face   ),
    .Q        (    ),
    .fim      (fim_face    ),
    .meio     (meio_face    )
);

// Contador de movimentos
contador_m #(
    .M(480), 
    .N(9)
) contador_movimento (
    .clock    (clock         ),
    .zera_as  (reset   ),
    .zera_s   (zera_movimento   ),
    .conta    (conta_movimento   ),
    .Q        (s_movimento    ),
    .fim      (fim_movimento    ),
    .meio     (   )
);

assign movimento_par = ~s_movimento[0];

interface_OV7670 imagem (
    .clock          (clock            ),
    .reset          (reset            ),
    .iniciar        (  captura_imagem       ),
    .rx_serial      (rx_serial),
    .db_partida_serial(),
    .saida_serial   (s_saida_serial_imagem),
    .db_estado      (s_db_estado_imagem),
    .hex0_pixel     (),
    .hex1_pixel     (),
    .hex2_pixel     (),
    .hex3_pixel     (),
    .hex4_pixel     (),
    .db_fim_recepcao (),
    .linha_quadrante_addr(s_linha_face),
    .coluna_quadrante_addr(s_coluna_face),
    .pixel          (s_pixel_face),
    .we_byte        (s_we_byte_face)
);

// RAM com os pixels lidos de uma face
ram_3x3 ram_pixels (
    .clk          (clock            ),
    .clear          (reset            ),
    .we             (s_we_byte_face),
    .data           (s_pixel_face),
    .addr1          (s_linha_face),
    .addr2          (s_coluna_face),
    .q              (s_pixel)
);

assign ram_pixels_addr1 = (ram_pixel_sel) ? s_linha_face : s_linha_cor;
assign ram_pixels_addr2 = (ram_pixel_sel) ? s_coluna_face : s_coluna_cor;

identifica_cores (
    .clock              (clock),
    .reset              (reset),
    .iniciar            (identificar_cores),
    .pixel              (s_pixel),
    .we_cor             (s_we_cor),
    .pronto             (cores_identificadas),
    .linha_pixel_addr   (s_linha_cor),
    .coluna_pixel_addr  (s_linha_cor),
    .cor_final          (s_cor_final),
    .db_estado          ()
)

// RAM cores
ram_3x3 #(.S_DATA(3))
ram_cores (
    .clk          (clock            ),
    .clear          (reset            ),
    .we             (s_we_cor),
    .data           (s_cor_final),
    .addr1          (s_linha_cor),
    .addr2          (s_coluna_cor),
    .q              (s_cor)
);

transmissao_serial transmitir_cores (
    .clock          (clock            ),
    .reset          (reset            ),
    .iniciar        (enviar_cores),
    .saida_serial   (),
    .pronto         (cores_transmitidas)
);



ram_movimentos ram_movimentos (
    .clk          (clock            ),
    .clear          (reset            ),
    .we             (),
    .data           (),
    .addr           (s_movimento),
    .q              (movimento)
);







endmodule