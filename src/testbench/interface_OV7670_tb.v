
`timescale 1ns/1ns

module interface_OV7670_tb;

    // Declaração de sinais
    reg         clock_in = 0;
    reg         reset_in = 0;
    reg         iniciar_in = 1;
    reg         VSYNC_in = 1;
    reg         HREF_in = 0;
    reg         PCLK_in = 0;
    reg [7:0]   D_in = 8'b0;
    wire        SDIOC_out;
    wire        SDIOD_out;
    wire        XCLK_out;
    wire        PWDN_out;
    wire [6:0]  db_estado_out;
	 wire [6:0] hex0_pixel;
    wire [6:0] hex1_pixel;
    wire [6:0] hex2_pixel;
    wire [6:0] hex3_pixel;
	 wire db_xclock_out;



    // Componente a ser testado (Device Under Test -- DUT)
    interface_OV7670  #(
        .LINES   (140),
        .COLUMNS (320),
        .S_DATA  (16),
        .S_LINE  (8),
        .S_COLUMN(9)
    )ut (
        .clock  (clock_in),
        .reset  (reset_in),
        .iniciar(iniciar_in),
        .VSYNC  (VSYNC_in),
        .HREF   (HREF_in),
        .PCLK   (PCLK_in),
        .D      (D_in),
        .SDIOC  (SDIOC_out),
        .SDIOD  (SDIOD_out),
        .XCLK   (XCLK_out),
        .PWDN   (PWDN_out),
        .db_estado(db_estado_out),
		  .hex0_pixel (hex0_pixel),
		  .hex1_pixel (hex1_pixel),
		  .hex2_pixel (hex2_pixel),
		  .hex3_pixel (hex3_pixel),
		  .db_xclock  (db_xclock_out)
    );



    // Configurações do clock
    parameter clockPeriod = 20; // clock de 50MHz
    integer caso;
    integer i, j;
    
    // Gerador de clock
    always #(clockPeriod/2) clock_in = ~clock_in;
    
    // Transmitir um frame com duas linhas e 4 bytes de dados cada
    
    // Reset
    initial begin
        $display("Inicio das simulacoes");
        reset_in = 1;
        #100 reset_in = 0;

        // Iniciar
        caso = 1;
        iniciar_in = 0;
        PCLK_in = 0;
        HREF_in = 0;
        VSYNC_in = 1;
        #(5*clockPeriod) ;

        // Inicio da transmissão do frame
        VSYNC_in = 0;
        #(5*clockPeriod) ;

        for(i=0; i<140; i = i+1) begin
            // Inicio da transmissão da linha
            HREF_in = 1;
            #(10*clockPeriod) ;

            for(j=0; j<320; j=j+1) begin
                caso = caso + 1;
                if (i == 31 && j == 65) begin
                    D_in = 8'b11000001;
                end
                else if (i == 78 && j == 65) begin
                    D_in = 8'b00000010;
                end
                else if (i == 125 && j == 65) begin
                    D_in = 8'b00000011;
                end
                else if (i == 31 && j == 139) begin
                    D_in = 8'b00000100;
                end
                else if (i == 78 && j == 139) begin
                    D_in = 8'b00000101;
                end
                else if (i == 125 && j == 139) begin
                    D_in = 8'b00000110;
                end
                else if (i == 31 && j == 233) begin
                    D_in = 8'b00000111;
                end
                else if (i == 78 && j == 233) begin
                    D_in = 8'b00001000;
                end
                else if (i == 125 && j == 233) begin
                    D_in = 8'b00001001;
                end
                else begin
                    D_in = 8'b00000000;
                end
                PCLK_in = 1;
                #(10*clockPeriod) ;
                PCLK_in = 0;
                #(10*clockPeriod) ;
                
            end

            // Fim da transmissão da linha
            HREF_in = 0;
            #(5*clockPeriod);
        end
       

        // Fim da transmissão do frame
        VSYNC_in = 1;
        #(5*clockPeriod) 


        // Fim da simulação
        $display("Fim das simulacoes");
        caso = 99; 
        $stop;
    end
    
endmodule