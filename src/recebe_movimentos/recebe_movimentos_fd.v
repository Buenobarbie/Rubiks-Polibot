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
 
module recebe_movimentos_fd (
    input wire         clock,
    input wire         reset,
    input wire         rx_serial,
    input wire         partida_serial,
    output wire        fim_recepcao,
    output wire        fim_transmissao,
    output wire        fim_movimentos,
    output wire        saida_serial,
    output wire  [2:0] movimento
);

    wire [7:0] s_dados;
    wire [2:0] s_movimento;
    wire s_fim_movimentos; 

    assign s_movimento = s_dados[2:0];
    assign movimento = s_movimento;

    assign s_fim_movimentos = ~s_dados[0] && ~s_dados[1] && ~s_dados[2];
    assign fim_movimentos = s_fim_movimentos; 

    // UART
    uart uart_movimentos (
        .clock           (clock),
        .reset           (reset),
        .partida         (partida_serial),
        .dados_ascii     (8'b11111111),
        .saida_serial    (saida_serial),
        .pronto          (fim_transmissao),
        .db_tick         (),
        .db_partida      (),
        .db_saida_serial (),
        .db_estado       ()
    );

    // Recepção Serial
    rx_serial_8N1 rx_serial_movimentos (
        .clock       (clock),
        .reset       (reset),
        .RX          (rx_serial     ),
        .pronto      (fim_recepcao  ),
        .dados_ascii (s_dados ),
        .db_clock    ( ),
        .db_tick     ( ),
        .db_dados    ( ),
        .db_estado   ( )
    );

endmodule
