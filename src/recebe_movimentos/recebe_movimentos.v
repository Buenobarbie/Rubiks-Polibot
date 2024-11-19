/* --------------------------------------------------------------------------
 *  Arquivo   : rx_serial_8N1.v
 * --------------------------------------------------------------------------
 *  Descricao : circuito de recepcao serial assincrona
 *              para comunicacao serial 8N1 
 *             (8 bits de dados, sem paridade, 1 stop bit)
 *              
 *  saidas: dados_ascii - display HEX1 e HEX0 e db_dados - leds
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *     Data        Versao  Autor              Descricao
 *     15/10/2024  5.0     Augusto Vaccarelli conversao para receptor
 *     29/10/2024  5.1     Edson Midorikawa   revisao do codigo
 * --------------------------------------------------------------------------
 */ 
 
module recebe_movimentos (
    input  clock,
    input  reset,
    input  iniciar,

    output  [2:0] movimento,
    output        zera_addr,
    output        saida_serial,
    output        conta_addr,
    output        we_movimento,
    output  [2:0] db_estado
);

    wire s_fim_transmissao;
    wire s_fim_recepcao;
    wire s_fim_movimentos;
    wire s_partida_serial;

    recebe_movimentos_fd U1_FD (
        .clock          (clock),
        .reset          (reset),
        .rx_serial      ( s_zera       ),
        .partida_serial  (s_partida_serial  ),
        .fim_recepcao    (s_fim_recepcao   ),
        .fim_transmissao (s_fim_transmissao),
        .fim_movimentos  (s_fim_movimentos ),
        .saida_serial    (saida_serial),
        .movimento       (movimento)
       
    );

    recebe_movimentos_uc U2_UC (
        .clock   (clock),
        .reset   (reset),
        .iniciar (iniciar),
        .fim_transmissao (s_fim_transmissao),
        .fim_recepcao    (s_fim_recepcao   ),
        .fim_movimentos  (s_fim_movimentos ),
        .zera_addr       (zera_addr        ),
        .partida_serial  (s_partida_serial ),
        .we_movimento       (we_movimento   ),
        .conta_addr    (conta_addr),
        .db_estado     (db_estado )
    );

endmodule
