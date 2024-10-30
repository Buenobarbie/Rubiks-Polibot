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
 
module interface_OV7670 #(parameter LINES=120, COLUMNS=320, S_DATA=16, S_LINE=7, S_COLUMN=9)
(
    input wire       clock,
    input wire       reset,
    input wire       iniciar,
    input wire       VSYNC,
    input wire       HREF,
    input wire       PCLK,
    input wire [7:0] D,
    input wire       SDIOC,
    input wire       SDIOD,
    output wire      XCLK,
    output wire      PWDN,
    output wire      RESET,
    output wire [6:0] db_estado ,
    output wire [6:0] hex0_pixel,
    output wire [6:0] hex1_pixel,
    output wire [6:0] hex2_pixel,
    output wire [6:0] hex3_pixel,
	 output wire db_vsync,
	 output wire db_href,
	 output wire db_pclock,
	 output wire db_xclock
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
    wire s_escreve_byte;
    wire s_we_byte;
	 wire [3:0] s_db_estado;
	 wire [15:0] s_pixel;

    // Sinais da camera
    assign PWDN  = 1'b0;
    assign RESET = 1'b1;
    


    // Edge detector
    edge_detector edge_iniciar (
        .clock  (clock ),
        .reset  (reset ),
        .sinal  (~iniciar),
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
        .fim_coluna_quadrante ( s_fim_coluna_quadrante ),
        .escreve_byte    (s_escreve_byte      ),
        .byte_estavel    ( s_byte_estavel   ),
        .we_byte         ( s_we_byte      ),
        .zera_linha_pixel( s_zera_linha_pixel),
        .zera_coluna_pixel( s_zera_coluna_pixel),
        .zera_linha_quadrante( s_zera_linha_quadrante),
        .zera_coluna_quadrante( s_zera_coluna_quadrante),
        .conta_linha_pixel( s_conta_linha_pixel),
        .conta_coluna_pixel( s_conta_coluna_pixel),
        .conta_linha_quadrante( s_conta_linha_quadrante),
        .conta_coluna_quadrante( s_conta_coluna_quadrante),
        .db_estado       ( s_db_estado        )
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
        .we_byte         ( s_we_byte     ),
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
        .escreve_byte    (s_escreve_byte),
        .XCLK            (XCLK),
        .pixel           (s_pixel)
       

    );
	 
	 hexa7seg hexa5_estado (
		.hexa(s_db_estado),
		.display(db_estado)
	 );
	 
	 hexa7seg hexa0_pixel_0_3 (
		.hexa(s_pixel[3:0]),
		.display(hex0_pixel)
	 );
	 
	 hexa7seg hexa1_pixel_4_7 (
		.hexa(s_pixel[7:4]),
		.display(hex1_pixel)
	 );
	 
	 hexa7seg hexa2_pixel_8_11 (
		.hexa(s_pixel[11:8]),
		.display(hex2_pixel)
	 );
	 
	 hexa7seg hexa3_pixel_12_15 (
		.hexa(s_pixel[15:12]),
		.display(hex3_pixel)
	 );
	 
	 assign db_vsync = VSYNC;
	 assign db_href = HREF;
	 assign db_pclock = PCLK;
	 assign db_xclock = XCLK;
	 
	 
endmodule
