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
 
module interface_OV7670_fd #(parameter LINES=120, COLUMNS=320, S_DATA=16, S_LINE=7, S_COLUMN=9)
(
    input wire         clock,
    input wire         reset,
    input wire         zera_linha_pixel,
    input wire         zera_coluna_pixel,
    input wire         conta_coluna_pixel,
    input wire         zera_linha_quadrante,
    input wire         zera_coluna_quadrante,
    input wire         we_byte,
    input wire         rx_serial,
    input wire         partida_serial,
    output wire        escreve_byte,
    output wire        fim_coluna_pixel,
    output wire        fim_transmissao,
	 output wire         fim_recepcao,
    output wire        saida_serial,
	 output wire        fim_linha_quadrante,
	 output wire        db_coluna_addr,
    output wire [15:0] pixel

);

    // Sinais de controle
    wire [S_LINE-1:0]   linha_pixel;
    wire [S_COLUMN-1:0] coluna_pixel;
    wire [1:0]          linha_quadrante_addr;
    wire [1:0]          coluna_quadrante_addr;
    wire                match_linha;
    wire                match_coluna;
    wire                we;
    wire                fim_coluna_quadrante;
    wire [15:0]         s_pixel;
    wire conta_linha_pixel;
    wire s_fim_coluna_pixel;
	 wire conta_linha_quadrante;
	 wire [7:0] s_byte;
	 wire s_fim_coluna_quadrante;


    assign conta_linha_pixel = conta_coluna_pixel && s_fim_coluna_pixel;

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
        .fim      ( s_fim_coluna_pixel  ),
        .meio     (    )
    );
	 
	 assign fim_coluna_pixel = s_fim_coluna_pixel;

    // Matchers
    // LINHA
    pixel_matcher #(
        .N(S_LINE),
        .VALUE1(20),
        .VALUE2(60),
        .VALUE3(100)
    ) matcher_linha (
        .value (linha_pixel),
        .match (match_linha)
    );

    // COLUNA
    pixel_matcher #(
        .N(S_COLUMN),
        .VALUE1(79),
        .VALUE2(159),
        .VALUE3(239)
    ) matcher_coluna (
        .value (coluna_pixel),
        .match (match_coluna)
    );

    // Verifica se o byte deve ser armazenado
    assign escreve_byte = match_linha && match_coluna;

    // Contador de linhas do quadrante armazenado
    contador_m #(
        .M(4), 
        .N(2)
    ) contador_linha_quadrante (
        .clock    (clock         ),
        .zera_as  (zera_linha_quadrante   ),
        .zera_s   (zera_linha_quadrante   ),
        .conta    (conta_linha_quadrante   ),
        .Q        (linha_quadrante_addr    ),
        .fim      ( fim_linha_quadrante),
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
	 
	 assign coluna_addr = coluna_quadrante_addr;

    // Registrador de pixel
    registrador_pixel  registrador_pixel (
        .clock  (clock ),
        .clear  (reset ),
        .enable (fim_recepcao),
        .D      (s_byte   ),
        .Q      (s_pixel)
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
        .we          (we_byte     ),
        .data        (s_pixel            ),
        .addr_line   (linha_quadrante_addr   ),
        .addr_column (coluna_quadrante_addr  ),
        .q           (   pixel  )
    );

    // UART
    uart uart_camera (
        .clock        (clock),
        .reset        (reset),
        .partida      (partida_serial),
        .dados_ascii  (8'b11111111),
        .saida_serial (saida_serial),
        .pronto       (fim_transmissao),
        .db_tick      (),
        .db_partida   (),
        .db_saida_serial (),
        .db_estado    ()
    );

    // Recepção serial
    rx_serial_8N1 rx_serial_camera (
        .clock      (clock         ),
        .reset      (reset         ),
        .RX         (rx_serial ),
        .pronto     (fim_recepcao),
        .dados_ascii(s_byte        ),
        .db_clock   (),
        .db_tick    (),
        .db_dados   (),
        .db_estado  ()
    );
	 
	 




endmodule
