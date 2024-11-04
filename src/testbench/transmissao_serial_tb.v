/* --------------------------------------------------------------------
 * Arquivo   : transmissao_serial_tb.v
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog do modulo transmissao_serial
 *
 *             1) Percorrer a memória e transmitir seus valores
 *
 * --------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autoras             
 *      3/11/2024  1.0     Bárbara Bueno       
 *                          Juliana Mitie
 *                          Tássyla Lima
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module transmissao_serial_tb;

  // Input signals
    reg clock_in;
    reg reset_in;
    reg iniciar_in;

  // Output signals
    wire saida_serial_out;
    wire fim_out;
    wire db_partida_serial_out;
    wire db_saida_serial_out;
    wire [6:0] db_estado_out;


  // Component to be tested (Device Under Test -- DUT)
    transmissao_serial uut (
        .clock(clock_in),
        .reset(reset_in),
        .iniciar(iniciar_in),
        .saida_serial(saida_serial_out),
        .fim(fim_out),
        .db_partida_serial(db_partida_serial_out),
        .db_saida_serial(db_saida_serial_out),
        .db_estado(db_estado_out)
    );

  // Configuração do clock
  parameter clockPeriod = 20; // em ns, f=50MHz

  // Gerador de clock
  always #(clockPeriod / 2) clock_in = ~clock_in;

  // Gera sinais de estimulo para a simulacao
  integer caso;
  initial begin
    $display("Inicio da simulacao");
    
    // Valores iniciais
    clock_in   = 1'b0;
    caso = 0;
    @(negedge clock_in); // espera borda de descida

    // Teste 1. 
    caso = 1;
    reset_in = 1'b1;
    #(5*clockPeriod) 
    reset_in = 1'b0;

    // Teste 2. 
    caso = 2;
    iniciar_in = 1'b1;
    #(5*clockPeriod);

    // Teste 3.
    // Esperar fim
    caso = 3;
    @(posedge fim_out);
    iniciar_in = 1'b0;
    

    // Final do testbench
    caso = 99;
    $display("fim da simulacao");
    $stop;
  end

endmodule