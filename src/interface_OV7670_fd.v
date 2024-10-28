/* --------------------------------------------------------------------------
 *  Arquivo   : interface_OV7670_fd.v
 * --------------------------------------------------------------------------
 *  Descricao : Fluxo de dados da interface com sensor OV7670 
 *              para captura de imagem
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autoras             
 *      27/10/2024  1.1     Bárbara Bueno       
 *                          Juliana Mitie
 *                          Tássyla Lima
 * --------------------------------------------------------------------------
 */
 
module interface_OV7670_fd #(parameter LINES=140, COLUMNS=320, S_DATA=16, S_LINE=8, S_COLUMN=9)
(
    input wire         clock,
    input wire         reset,
    input wire         VSYNC,
    input wire         PCLK,
    input wire [7:0]   D,
    input wire         byte_estavel,
    input wire         zera_linha_pixel,
    input wire         zera_coluna_pixel,
    input wire         conta_linha_pixel,
    input wire         conta_coluna_pixel,
    input wire         zera_linha_quadrante,
    input wire         zera_coluna_quadrante,
    input wire         conta_linha_quadrante,
    input wire         conta_coluna_quadrante,
    output wire        transmite_frame,
    output wire        transmite_byte,
    output wire        fim_coluna_quadrante,
    output wire        pixel_armazenado,
    output wire [15:0]  pixel
);

    // Sinais de controle
    wire [S_LINE-1:0]   linha_pixel;
    wire [S_COLUMN-1:0] coluna_pixel;
    wire [1:0]          linha_quadrante_addr;
    wire [1:0]          coluna_quadrante_addr;
    wire                match_linha;
    wire                match_coluna;
    wire                we;
    wire [15:0]         s_byte;


    // Edge detector
    edge_detector edge_frame (
        .clock  (clock ),
        .reset  (reset ),
        .sinal  (~VSYNC),
        .pulso(transmite_frame)
    );

    edge_detector edge_byte (
        .clock  (clock),
        .reset  (reset),
        .sinal  (PCLK ),
        .pulso(transmite_byte)
    );

    // Contador de linhas dos pixels lidos
    contador_m #(
        .M(LINES), 
        .N(S_LINE)
    ) contador_linha_pixel (
        .clock    (clock         ),
        .zera_as  (zera_linha_pixel   ),
        .zera_s   (zera_linha_pixel   ),
        .conta    (conta_linha_pixel   ),
        .Q        (linha_pixel    ),
        .fim      (     ),
        .meio     (    )
    );

    // Contador de colunas dos pixels lidos
    contador_m #(
        .M(COLUMNS), 
        .N(S_COLUMN)
    ) contador_coluna_pixel (
        .clock    (clock         ),
        .zera_as  (zera_coluna_pixel  ),
        .zera_s   (zera_coluna_pixel  ),
        .conta    (conta_coluna_pixel  ),
        .Q        (coluna_pixel   ),
        .fim      (    ),
        .meio     (    )
    );

    // Matchers
    pixel_matcher #(
        .N(S_LINE),
        .VALUE1(32),
        .VALUE2(79),
        .VALUE3(126)
    ) matcher_linha (
        .value (linha_pixel),
        .match (match_linha)
    );

    pixel_matcher #(
        .N(S_COLUMN),
        .VALUE1(65),
        .VALUE2(139),
        .VALUE3(233)
    ) matcher_coluna (
        .value (coluna_pixel),
        .match (match_coluna)
    );

    // Verifica se o byte deve ser armazenado
    assign we = match_linha && match_coluna && byte_estavel;
    assign pixel_armazenado = we;


    // Contador de linhas do quadrante armazenado
    contador_m #(
        .M(3), 
        .N(2)
    ) contador_linha_quadrante (
        .clock    (clock         ),
        .zera_as  (zera_linha_quadrante   ),
        .zera_s   (zera_linha_quadrante   ),
        .conta    (conta_linha_quadrante   ),
        .Q        (linha_quadrante_addr    ),
        .fim      ( ),
        .meio     (    )
    );

    // Contador de colunas do quadrante armazenado
    contador_m #(
        .M(3), 
        .N(2)
    ) contador_coluna_quadrante (
        .clock    (clock         ),
        .zera_as  (zera_coluna_quadrante  ),
        .zera_s   (zera_coluna_quadrante  ),
        .conta    (conta_coluna_quadrante  ),
        .Q        (coluna_quadrante_addr   ),
        .fim      (fim_coluna_quadrante    ),
        .meio     (    )
    );

    // Registrador de pixel
    registrador_pixel  registrador_pixel (
        .clock  (clock ),
        .clear  (reset ),
        .enable (byte_estavel),
        .D      (D     ),
        .Q      (s_byte)
    );

    // Memoria de armazenamento
    ram #(
        .LINES  (3 ),
        .COLUMNS(3),
        .S_DATA (S_DATA),
        .S_LINE (2),
        .S_COLUMN(2)
    ) memoria (
        .clk         (clock        ),
        .clear       (reset        ),
        .we          (we     ),
        .data        (s_byte            ),
        .addr_line   (linha_quadrante_addr   ),
        .addr_column (coluna_quadrante_addr  ),
        .q           (pixel     )
    );

endmodule
