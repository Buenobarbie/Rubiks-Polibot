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
    input wire       rx_serial,
	 output wire      db_partida_serial,
	 output wire      saida_serial,
	 output wire [6:0] db_estado,
	 output wire [6:0] hex0_pixel,
	 output wire [6:0] hex1_pixel,
	 output wire [6:0] hex2_pixel,
	 output wire [6:0] hex3_pixel,
	 output wire [6:0] hex4_pixel,
	 output wire       db_fim_recepcao


);

    // Sinais internos
    wire s_iniciar;
    wire s_zera_linha_pixel;
    wire s_zera_coluna_pixel;
    wire s_conta_coluna_pixel;
    wire s_zera_linha_quadrante;
    wire s_zera_coluna_quadrante;
    wire s_we_byte;
    wire s_fim_recepcao;
    wire s_partida_serial;
    wire s_escreve_byte;
    wire s_fim_coluna_pixel;
    wire s_fim_transmissao;
    wire [15:0] s_pixel;
    wire [3:0] s_db_estado;
	 wire s_zera_linha;
	 wire s_zera_coluna;
	 wire s_conta_linha_quadrante;
    wire s_conta_coluna_quadrante;
	 wire s_fim_linha_quadrante;
	 wire [3:0] db_coluna_addr;
	 
	 assign db_partida_Serial = s_partida_serial;



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
        .fim_transmissao (s_fim_transmissao),
        .fim_recepcao    (s_fim_recepcao   ),
        .escreve_byte    (s_escreve_byte   ),
        .fim_coluna_quadrante (s_fim_coluna_quadrante),
        .zera_linha_pixel      (s_zera_linha_pixel     ),
        .zera_coluna_pixel     (s_zera_coluna_pixel    ),
        .zera_linha_quadrante (s_zera_linha_quadrante),
        .zera_coluna_quadrante (s_zera_coluna_quadrante),
        .we_byte         (s_we_byte        ),
        .conta_linha_quadrante (s_conta_linha_quadrante),
        .conta_coluna_quadrante (s_conta_coluna_quadrante),
        .conta_coluna_pixel (s_conta_coluna_pixel),
        .partida_serial  (s_partida_serial ),
        .db_estado       (s_db_estado      ),
		  .fim_linha_quadrante (s_fim_linha_quadrante)
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
        .zera_linha_pixel (s_zera_linha_pixel),
        .zera_coluna_pixel (s_zera_coluna_pixel),
        .conta_coluna_pixel (s_conta_coluna_pixel),
        .zera_linha_quadrante (s_zera_linha_quadrante),
        .zera_coluna_quadrante (s_zera_coluna_quadrante),
		  .conta_linha_quadrante (s_conta_linha_quadrante),
		  .conta_coluna_quadrante (s_conta_coluna_quadrante),
        .rx_serial       (rx_serial),
        .we_byte         (s_we_byte     ),
        .fim_recepcao    (s_fim_recepcao),
        .partida_serial  (s_partida_serial),
        .escreve_byte    (s_escreve_byte  ),
        .fim_coluna_pixel (s_fim_coluna_pixel),
        .fim_transmissao (s_fim_transmissao),
        .saida_serial    (saida_serial ),
        .pixel           (s_pixel        ),
		  .fim_linha_quadrante (s_fim_linha_quadrante),
		  .db_coluna_addr (db_coluna_addr)

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
	 
	 hexa7seg hexa4_pixel_12_15 (
		.hexa(db_coluna_addr),
		.display(hex4_pixel)
	 );

	assign db_fim_recepcao = s_fim_recepcao;
	 
	 
endmodule
