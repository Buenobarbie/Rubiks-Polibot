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
    input obter_movimentos,
    input rx_serial,
    input sel_serial1,
    input sel_serial2,
    output imagem_recebida,
    output cores_identificadas,
    output cores_transmitidas,
    output fim_face,
    output fim_movimento,
    output movimento_par,
    output meio_face,
    output movimentos_recebidos,
    output fim_rom,
    output pwm_base,
    output pwm_tampa,
    output pwm_peteleco,
    output saida_serial,
    output [2:0] db_movimento,

);

wire [6:0] s_db_estado_imagem;
wire [1:0] s_linha_face;
wire [1:0] s_coluna_face;
wire [15:0] s_pixel_face;
wire [15:0] s_pixel;
wire s_we_byte_face;
wire [1:0] w_linha_cor;
wire [1:0] w_coluna_cor;
wire [1:0] r_linha_cor;
wire [1:0] r_coluna_cor;
wire [1:0] linha_cor;
wire [1:0] coluna_cor;
wire [1:0] ram_pixels_addr1;
wire [1:0] ram_pixels_addr2;

wire s_we_cor;
wire [2:0] s_cor_final;
wire [2:0] s_cor;

wire [8:0] w_addr_movimento;
wire       we_movimento;
wire [2:0] w_data_movimento;

wire [8:0] r_addr_movimento;
wire [8:0] addr_movimento;

wire [2:0] movimento;


// Saidas seriais
wire s_saida_serial_imagem;
wire s_saida_serial_cores;
wire s_saida_serial_movimentos;

// 00 : imagem
// 01: imagem
// 10: cores
// 11: movimentos

assign saida_serial = (~sel_serial1) ? s_saida_serial_imagem : (~sel_serial2) ? s_saida_serial_cores : s_saida_serial_movimentos;

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
    .Q        (r_addr_movimento    ),
    .fim      (fim_movimento    ),
    .meio     (   )
);

assign movimento_par = ~r_addr_movimento[0];

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

assign ram_pixels_addr1 = (ram_pixel_sel) ? s_linha_face : w_linha_cor;
assign ram_pixels_addr2 = (ram_pixel_sel) ? s_coluna_face : w_coluna_cor;

identifica_cores (
    .clock              (clock),
    .reset              (reset),
    .iniciar            (identificar_cores),
    .pixel              (s_pixel),
    .we_cor             (s_we_cor),
    .pronto             (cores_identificadas),
    .linha_pixel_addr   (w_linha_cor),
    .coluna_pixel_addr  (w_coluna_cor),
    .cor_final          (s_cor_final),
    .db_estado          ()
)

assign linha_cor = (sel_cor) ? w_linha_cor : r_linha_cor;   
assign coluna_cor = (sel_cor) ? w_coluna_cor : r_coluna_cor;

// RAM cores
ram_3x3 #(.S_DATA(3))
ram_cores (
    .clk          (clock            ),
    .clear          (reset            ),
    .we             (s_we_cor),
    .data           (s_cor_final),
    .addr1          (linha_cor),
    .addr2          (coluna_cor),
    .q              (s_cor)
);

transmissao_serial transmitir_cores (
    .clock          (clock            ),
    .reset          (reset            ),
    .iniciar        (enviar_cores),
    .saida_serial   (s_saida_serial_cores),
    .fim         (cores_transmitidas),
    .db_partida_serial (),
    .db_saida_serial (),
    .dados_pixel   (s_cor),
    .addr_linha    (r_linha_cor),
    .addr_coluna   (r_coluna_cor)
);

assign addr_movimento = (sel_movimento) ? w_addr_movimento : r_addr_movimento;

ram_movimentos ram_movimentos (
    .clk          (clock            ),
    .clear          (reset            ),
    .we             (we_movimento),
    .data           ()w_data_movimento,
    .addr           (addr_movimento),
    .q              (movimento)
);


// recebe_movimentos recebe_movimentos(
    // .clk             (clock),
    // .reset           (reset),
    // .iniciar         (obter_movimentos),
    // .w_addr_movimento  (w_addr_movimento),
    // .we_movimento      (we_movimento),
    // .w_data_movimento  (w_data_movimento),
    // .saida_serial      (s_saida_serial_movimentos)
// );


gerenciador_servos gerenciador_servos(
    .clock          (clock),
    .reset          (reset),
    .iniciar        (aciona_movimento),
    .move           (movimento),
    .pronto         (fim_movimento),
    .pwm_peteleco   (pwm_peteleco),
    .pwm_tampa      (pwm_tampa),
    .pwm_base       (pwm_base)
);




assign db_movimento = movimento;

endmodule