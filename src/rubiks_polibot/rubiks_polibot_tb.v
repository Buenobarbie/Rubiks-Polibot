
`timescale 1ns/1ns

module rubiks_polibot_tb;

    // Declaração de sinais
    reg clock_in = 0;
    reg reset_in = 0;
    reg iniciar_in = 1;
    wire saida_serial_out;
    wire rx_serial_in;
    wire pwm_peteleco_out;
    wire pwm_tampa_out;
    wire pwm_base_out;
    wire [6:0] db_estado_out;
    wire [2:0] db_movimento_out;

    reg partida_serial_in = 0;
    reg [7:0] dados_serial_in = 0;
    wire pronto_saida_serial_out;
    wire fim_recepcao_out;
    wire [7:0] s_byte_out;



    // Componente a ser testado (Device Under Test -- DUT)
    rubiks_polibot dut (
        .clock  (clock_in),
        .reset  (reset_in),
        .iniciar(iniciar_in),
        .rx_serial  (saida_serial_out),
        .saida_serial (rx_serial_in),
        .pwm_peteleco (pwm_peteleco_out),
        .pwm_tampa (pwm_tampa_out),
        .pwm_base (pwm_base_out),
        .db_estado (db_estado_out),
        .db_movimento (db_movimento_out)
    );

    uart uart_teste(
       .clock           (clock_in), 
       .reset           (reset_in),
       .partida         (partida_serial_in), 
       .dados_ascii     (dados_serial_in  ),
       .saida_serial    (saida_serial_out  ),
       .pronto          (pronto_saida_serial_out),
       .db_tick         (  ), 
       .db_partida      (  ),
       .db_saida_serial (  ),
       .db_estado       (  )
   );

     // Recepção serial
    rx_serial_8N1 rx_serial_camera (
        .clock      (clock_in         ),
        .reset      (reset_in         ),
        .RX         (rx_serial_in ),
        .pronto     (fim_recepcao_out),
        .dados_ascii(s_byte_out       ),
        .db_clock   (),
        .db_tick    (),
        .db_dados   (),
        .db_estado  ()
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
        iniciar_in = 1;
        #100 iniciar_in = 0;

        @(s_byte_out == 8'b11111111)

        // Enviar 16 dados
        caso = 2;
        // 100a azul
        dados_serial_in = 8'h10;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h0a;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        caso = 3;
        // 6800 vermelho
        dados_serial_in = 8'h68;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h00;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)


        caso = 4;
        // 03e5 verde
        dados_serial_in = 8'h03;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'hE5;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        caso = 5;
        // 5b23 amarelo
        dados_serial_in = 8'h5b;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h23;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)


                // Enviar 16 dados
        caso = 2;
        // 100a azul
        dados_serial_in = 8'h10;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h0a;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        caso = 3;
        // 6800 vermelho
        dados_serial_in = 8'h68;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h00;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)


        caso = 4;
        // 03e5 verde
        dados_serial_in = 8'h03;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'hE5;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        caso = 5;
        // 5b23 amarelo
        dados_serial_in = 8'h5b;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h23;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)


                // Enviar 16 dados
        caso = 2;
        // 100a azul
        dados_serial_in = 8'h10;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h0a;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        caso = 3;
        // 6800 vermelho
        dados_serial_in = 8'h68;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h00;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)


        caso = 4;
        // 03e5 verde
        dados_serial_in = 8'h03;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'hE5;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        caso = 5;
        // 5b23 amarelo
        dados_serial_in = 8'h5b;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h23;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)


                // Enviar 16 dados
        caso = 2;
        // 100a azul
        dados_serial_in = 8'h10;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h0a;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        caso = 3;
        // 6800 vermelho
        dados_serial_in = 8'h68;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h00;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)


        caso = 4;
        // 03e5 verde
        dados_serial_in = 8'h03;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'hE5;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        caso = 5;
        // 5b23 amarelo
        dados_serial_in = 8'h5b;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        dados_serial_in = 8'h23;
        partida_serial_in = 1;
#5
partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)


        caso = 16;
        // Espera 54 transmissoes
        for (i = 0; i < 54; i = i + 1) begin
            @(fim_recepcao_out == 1);
        end

        // Transmitir os movimentos
        @(s_byte_out == 8'b11111111)

        // Enviar 3 dados seguiso de um dado nulo
        caso = 17;
        // 001 movimento 1
        dados_serial_in = 8'h01;
        partida_serial_in = 1;
        #5
        partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        caso = 18;
        // 002 movimento 2
        dados_serial_in = 8'h02;
        partida_serial_in = 1;
        #5
        partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        caso = 19;
        // 003 movimento 3
        dados_serial_in = 8'h03;
        partida_serial_in = 1;
        #5
        partida_serial_in = 0;

        @(pronto_saida_serial_out == 1)

        caso = 20;
        // 000 movimento nulo
        dados_serial_in = 8'h00;
        partida_serial_in = 1;
        #5
        partida_serial_in = 0;
        @(pronto_saida_serial_out == 1)

        














        $display("Fim das simulacoes");
        caso = 99; 
        $stop;
    end
    
endmodule