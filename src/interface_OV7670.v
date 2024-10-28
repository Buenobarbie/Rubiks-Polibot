/* --------------------------------------------------------------------------
 *  Arquivo   : interface_OV7670.v
 * --------------------------------------------------------------------------
 *  Descricao : Código da interface do sensor OV7670 com a FPGA
    *           para caputra e armazenamento dos bytes de uma imagem 
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autoras             
 *      20/10/2024  1.0     Bárbara Bueno       
 *                          Juliana Mitie
 *                          Tássyla Lima
 * --------------------------------------------------------------------------
 */

// SINAIs DO MODULO OV7670
// VDD**	Supply	     Power supply
// GND	    Supply	     Ground level
// SDIOC	Input	     SCCB clock
// SDIOD	Input/Output SCCB data
// VSYNC	Output	     Vertical synchronization
// HREF	    Output	     Horizontal synchronization
// PCLK	    Output	     Pixel clock
// XCLK	    Input	     System clock
// D0-D7	Output	     Video parallel output
// RESET	Input	     Reset (Active low)
// PWDN	    Input	     Power down (Active high)
 
module interface_OV7670 #(parameter LINES=140, COLUMNS=320, S_DATA=16, S_LINE=8, S_COLUMN=9)
(
    input wire       clock,
    input wire       reset,
    input wire       iniciar,
    input wire       VSYNC,
    input wire       HREF,
    input wire       PCLK,
    input wire [7:0] D,
    output wire      SDIOC,
    output wire      SDIOD,
    output wire      XCLK,
    output wire      PWDN,
    output wire [3:0] db_estado ,
    output wire [15:0] pixel
);

    // Sinais internos
    wire s_iniciar;
    wire s_transmite_frame;
    wire s_transmite_byte;
    wire s_write_en;
    wire s_zera_linha;
    wire s_zera_coluna;
    wire s_conta_linha;
    wire s_conta_coluna;
    wire s_pixel_armazenado;
    wire s_fim_coluna_quadrante;
    wire s_byte_estavel;
    wire s_zera_linha_pixel;
    wire s_zera_coluna_pixel;
    wire s_zera_linha_quadrante;
    wire s_zera_coluna_quadrante;
    wire s_conta_linha_pixel;
    wire s_conta_coluna_pixel;
    wire s_conta_linha_quadrante;
    wire s_conta_coluna_quadrante;
    


    // Edge detector
    edge_detector edge_iniciar (
        .clock  (clock ),
        .reset  (reset ),
        .sinal  (iniciar),
        .pulso  (s_iniciar)
    );

    // Unidade de controle
    interface_OV7670_uc uc_OV7670 (
        .clock           (clock            ),
        .reset           (reset            ),
        .iniciar        (s_iniciar       ),
        .VSYNC           (VSYNC            ),
        .HREF            (HREF             ),
        .transmite_frame (s_transmite_frame),
        .transmite_byte  (s_transmite_byte ),
        .pixel_armazenado(s_pixel_armazenado ),
        .fim_coluna_quadrante ( s_fim_coluna_quadrante ),
        .byte_estavel    ( s_byte_estavel   ),
        .zera_linha_pixel( s_zera_linha_pixel),
        .zera_coluna_pixel( s_zera_coluna_pixel),
        .zera_linha_quadrante( s_zera_linha_quadrante),
        .zera_coluna_quadrante( s_zera_coluna_quadrante),
        .conta_linha_pixel( s_conta_linha_pixel),
        .conta_coluna_pixel( s_conta_coluna_pixel),
        .conta_linha_quadrante( s_conta_linha_quadrante),
        .conta_coluna_quadrante( s_conta_coluna_quadrante),
        .db_estado       ( db_estado        )
    );

    // Fluxo de dados
    interface_OV7670_fd  #(
        .LINES   (LINES  ),
        .COLUMNS (COLUMNS),
        .S_DATA  (S_DATA ),
        .S_LINE  (S_LINE ),
        .S_COLUMN(S_COLUMN)
    ) fd_OV7670 (
        .clock           (clock),
        .reset           (reset), 
        .VSYNC           (VSYNC),
        .PCLK            (PCLK ),
        .D               (D    ),
        .byte_estavel    (s_byte_estavel   ),
        .zera_linha_pixel( s_zera_linha_pixel),
        .zera_coluna_pixel( s_zera_coluna_pixel),
        .conta_linha_pixel( s_conta_linha_pixel),
        .conta_coluna_pixel( s_conta_coluna_pixel),
        .zera_linha_quadrante( s_zera_linha_quadrante),
        .zera_coluna_quadrante( s_zera_coluna_quadrante),
        .conta_linha_quadrante( s_conta_linha_quadrante),
        .conta_coluna_quadrante( s_conta_coluna_quadrante),
        .transmite_frame (s_transmite_frame),
        .transmite_byte  (s_transmite_byte ),
        .fim_coluna_quadrante ( s_fim_coluna_quadrante ),
        .pixel_armazenado(s_pixel_armazenado ),
        .pixel           (pixel)
       

    );
endmodule
