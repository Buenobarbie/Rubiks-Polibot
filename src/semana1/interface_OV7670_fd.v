/* --------------------------------------------------------------------------
 *  Arquivo   : interface_OV7670_fd.v
 * --------------------------------------------------------------------------
 *  Descricao : Fluxo de dados da interface com sensor OV7670 
 *              para captura de imagem
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autoras             
 *      20/10/2024  1.0     Bárbara Bueno       
 *                          Juliana Mitie
 *                          Tássyla Lima
 * --------------------------------------------------------------------------
 */
 
module interface_OV7670_fd #(parameter LINES=176, COLUMNS=288, S_DATA=8, S_LINE=8, S_COLUMN=9)
(
    input wire         clock,
    input wire         reset,
    input wire         VSYNC,
    input wire         PCLK,
    input wire [7:0]   D,
    input wire         write_en,
    input wire         zera_linha,
    input wire         zera_coluna,
    input wire         conta_linha,
    input wire         conta_coluna,
    output wire        transmite_frame,
    output wire        transmite_byte,
    output wire [7:0]  s_byte
);

    // Sinais de controle
    wire [S_LINE-1:0]   linha_addr; 
    wire [S_COLUMN-1:0] coluna_addr;

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

    // Contador de linhas
    contador_m #(
        .M(LINES), 
        .N(S_LINE)
    ) contador_linha (
        .clock    (clock         ),
        .zera_as  (zera_linha   ),
        .zera_s   (zera_linha   ),
        .conta    (conta_linha   ),
        .Q        (linha_addr    ),
        .fim      (     ),
        .meio     (    )
    );

    // Contador de colunas
    contador_m #(
        .M(COLUMNS), 
        .N(S_COLUMN)
    ) contador_coluna (
        .clock    (clock         ),
        .zera_as  (zera_coluna  ),
        .zera_s   (zera_coluna  ),
        .conta    (conta_coluna  ),
        .Q        (coluna_addr   ),
        .fim      (    ),
        .meio     (    )
    );

    // Memoria de armazenamento
    ram #(
        .LINES  (LINES ),
        .COLUMNS(COLUMNS),
        .S_DATA (S_DATA),
        .S_LINE (S_LINE),
        .S_COLUMN(S_COLUMN)
    ) memoria (
        .clk         (clock        ),
        .clear       (reset        ),
        .we          (write_en     ),
        .data        (D            ),
        .addr_line   (linha_addr   ),
        .addr_column (coluna_addr  ),
        .q           (s_byte       ),
    );

endmodule
