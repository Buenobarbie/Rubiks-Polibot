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
 
module interface_OV7670 #(parameter LINES=176, COLUMNS=288, S_DATA=8, S_LINE=8, S_COLUMN=9)
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
    output wire [3:0] db_estado 
);

    // Sinais internos
    wire s_inciciar;
    wire s_transmite_frame;
    wire s_transmite_byte;
    wire s_write_en;
    wire s_zera_linha;
    wire s_zera_coluna;
    wire s_conta_linha;
    wire s_conta_coluna;

    // Edge detector
    edge_detector edge_frame (
        .clock  (clock ),
        .reset  (reset ),
        .sinal  (iniciar),
        .pulso  (s_inciciar)
    );

    // Unidade de controle
    interface_OV7670_uc uc_OV7670 (
        .clock           (clock            ),
        .reset           (reset            ),
        .inciciar        (s_inciciar       ),
        .VSYNC           (VSYNC            ),
        .HREF            (HREF             ),
        .transmite_frame (s_transmite_frame),
        .transmite_byte  (s_transmite_byte ),
        .PWDN            (PWDN             ),
        .write_en        (s_write_en       ),
        .zera_linha      (s_zera_linha     ),
        .zera_coluna     (s_zera_coluna    ),
        .conta_linha     (s_conta_linha    ),
        .conta_coluna    (s_conta_coluna   ),
        .db_estado       (db_estado        )
    );

    // Fluxo de dados
    interface_OV7670_fd fd_OV7670 #(
        .LINES   (LINES  ),
        .COLUMNS (COLUMNS),
        .S_DATA  (S_DATA ),
        .S_LINE  (S_LINE ),
        .S_COLUMN(S_COLUMN)
    ) (
        .clock           (clock),
        .reset           (reset), 
        .VSYNC           (VSYNC),
        .PCLK            (PCLK ),
        .D               (D    ),
        .write_en        (s_write_en       ),
        .zera_linha      (s_zera_linha     ),
        .zera_coluna     (s_zera_coluna    ),  // (desconectado)
        .conta_linha     (s_conta_linha    ),
        .conta_coluna    (s_conta_coluna   ),
        .transmite_frame (s_transmite_frame),
        .transmite_byte  (s_transmite_byte ),
        .s_byte          (    )
       

    );
endmodule
