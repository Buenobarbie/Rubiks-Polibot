
`timescale 1ns/1ns

module identifica_cores_tb;

    // Declaração de sinais
    reg         clock_in = 0;
    reg         reset_in = 0;
    reg         iniciar_in = 1;
    wire  [15:0] pixel_in;
    wire         we_cor_out;
    wire         pronto_out;
    wire [1:0]  linha_pixel_addr_out;
    wire [1:0]  coluna_pixel_addr_out;
    wire [2:0]  cor_final_out;
    wire [3:0]  db_estado_out;





    // Componente a ser testado (Device Under Test -- DUT)
    identifica_cores dut (
        .clock  (clock_in),
        .reset  (reset_in),
        .iniciar(iniciar_in),
        .pixel  (pixel_in),
        .we_cor (we_cor_out),
        .pronto (pronto_out),
        .linha_pixel_addr (linha_pixel_addr_out),
        .coluna_pixel_addr (coluna_pixel_addr_out),
        .cor_final (cor_final_out),
        .db_estado (db_estado_out)
    );

    rom_tb rom_tb (
        .clk (clock_in),
        .clear (reset_in),
        .addr1 (linha_pixel_addr_out),
        .addr2 (coluna_pixel_addr_out),
        .q (pixel_in)
    );



    // Configurações do clock
    parameter clockPeriod = 20; // clock de 50MHz
    integer caso;
    // integer i, j;
    
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
        #(5*clockPeriod) ;

        // Inicio da identificação das cores
        // pixel_in = 16'h4801;
        iniciar_in = 1;
        #(5*clockPeriod) ;
        iniciar_in = 0;

        // Esperar fim da identificação
        @( pronto_out );





        // Fim da simulação
        $display("Fim das simulacoes");
        caso = 99; 
        $stop;
    end
    
endmodule