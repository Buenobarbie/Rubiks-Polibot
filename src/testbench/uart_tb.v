`timescale 1ns/1ns

module uart_tb;

    // declaração de sinais
    reg       clock_in;
    reg       reset_in;
    reg       partida_in;
    reg [7:0] dados_ascii_8_in;
    wire      saida_serial_out;
    wire      pronto_out;

    // componente a ser testado (Device Under Test -- DUT)
    uart_tb dut (
        .clock           ( clock_in         ),
        .reset           ( reset_in         ),
        .partida         ( partida_in       ),
        .dados_ascii     ( dados_ascii_8_in ),
        .saida_serial    ( saida_serial_out ),
        .pronto          ( pronto_out       ),
        .db_tick         (                  ), // Porta aberta (desconectada)
        .db_partida      (                  ), // Porta aberta (desconectada)
        .db_saida_serial (                  ), // Porta aberta (desconectada)
        .db_estado       (                  )  // Porta aberta (desconectada)
    );

    // configuração do clock
    parameter clockPeriod = 20; // em ns, f=50MHz

    // gerador de clock
    always #(clockPeriod / 2) clock_in = ~clock_in;

    // vetor de teste
    reg [6:0] vetor_teste [0:3];
    integer caso;

    // geração dos sinais de entrada (estímulos)
    initial begin
        $display("Inicio da simulacao");

        // inicialização do vetor de teste
        vetor_teste[0] = 8'b10110101;  
        vetor_teste[1] = 8'b11010101;  
        vetor_teste[2] = 8'b11111110;  
        vetor_teste[3] = 8'b11111111;  

        // valores iniciais
        clock_in = 1'b0;
        reset_in = 0;
        caso     = 0;

        // reset
        partida_in = 0;
        @(negedge clock_in); 
        reset_in = 1;
        #(20*clockPeriod);
        reset_in = 0;
        $display("... reset gerado");
        @(negedge clock_in);
        #(50*clockPeriod);

        // casos de teste
        for (caso = 0; caso < 4; caso = caso + 1) begin
            $display("caso: %0d", caso);

            // dado de entrada do vetor de teste
            dados_ascii_8_in = vetor_teste[caso];
            #(20*clockPeriod);

            // acionamento da partida
            @(negedge clock_in);
            partida_in = 1;
            #(25*clockPeriod); 
            partida_in = 0;

            // espera final da transmissão
            wait (pronto_out == 1'b1);

            // intervalo entre casos de teste
            #(500*clockPeriod);
        end

        // fim da simulação
        caso = 99;
        $display("Fim da simulacao");
        #(10*clockPeriod); // aguarda um pequeno tempo para garantir que o clock pare
        $stop;
    end

endmodule