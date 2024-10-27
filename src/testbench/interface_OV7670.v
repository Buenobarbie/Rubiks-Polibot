
`timescale 1ns/1ns

module interface_OV7670_tb;

    // Declaração de sinais
    reg         clock_in = 0;
    reg         reset_in = 0;
    reg         iniciar_in = 0;
    reg         VSYNC_in = 1;
    reg         HREF_in = 0;
    reg         PCLK_in = 0;
    reg [7:0]   D_in = 8'b0;
    wire        SDIOC_out;
    wire        SDIOD_out;
    wire        XCLK_out;
    wire        PWDN_out;
    wire [3:0]  db_estado_out;



    // Componente a ser testado (Device Under Test -- DUT)
    interface_OV7670 ut #(
        .LINES   (2),
        .COLUMNS (2),
        .S_DATA  (8),
        .S_LINE  (1),
        .S_COLUMN(1)
    )(
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
        .db_estado(db_estado_out)
    );



    // Configurações do clock
    parameter clockPeriod = 20; // clock de 50MHz
    // Gerador de clock
    always #(clockPeriod/2) clock_in = ~clock_in;
    
    // Transmitir um frame com duas linhas e 4 bytes de dados cada
    
    // Reset
    initial begin
        $display("Inicio das simulacoes");
        reset_in = 1;
        #100 reset_in = 0;

        // Iniciar
        iniciar_in = 1;

        // Inicio da transmissão do frame
        VSYNC_in = 0;
        #10

        // Inicio da transmissão da linha 1
        HREF_in = 1;
        #10
        // Byte 1
        D_in = 8'b10101010;
        PCLK_in = 1;
        #10
        PCLK_in = 0;

        // Byte 2
        D_in = 8'b01010101;
        PCLK_in = 1;
        #10
        PCLK_in = 0;

        // Byte 3
        D_in = 8'b11001100;
        PCLK_in = 1;
        #10
        PCLK_in = 0;

        // Byte 4
        D_in = 8'b00110011;
        PCLK_in = 1;
        #10
        PCLK_in = 0;

        // Fim da transmissão da linha 1
        HREF_in = 0;
        #10

        // Inicio da transmissão da linha 2
        HREF_in = 1;
        #10

        // Byte 1
        D_in = 8'b11110000;
        PCLK_in = 1;
        #10
        PCLK_in = 0;
        
        // Byte 2
        D_in = 8'b00001111;
        PCLK_in = 1;
        #10
        PCLK_in = 0;

        // Byte 3
        D_in = 8'b11110000;
        PCLK_in = 1;
        #10
        PCLK_in = 0;

        // Byte 4
        D_in = 8'b00001111;
        PCLK_in = 1;
        #10
        PCLK_in = 0;

        // Fim da transmissão da linha 2
        HREF_in = 0;
        #10

        // Fim da transmissão do frame
        VSYNC_in = 1;
        #10


        // Fim da simulação
        $display("Fim das simulacoes");
        caso = 99; 
        $stop;
    end
    
endmodule