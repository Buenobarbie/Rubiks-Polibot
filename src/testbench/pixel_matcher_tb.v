/* --------------------------------------------------------------------
 * Arquivo   : pixel_matcher_tb.v
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog do modulo pixel_matcher
 *
 *             1) Plano de teste com 5 casos de testes
 *
 * --------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autoras             
 *      27/10/2024  1.0     Bárbara Bueno       
 *                          Juliana Mitie
 *                          Tássyla Lima
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module pixel_matcher_tb;

  // Input signals
  reg [7:0]   value_in;
  reg         clock_in;

  // Output signals
  wire match;

  // Component to be tested (Device Under Test -- DUT)
    pixel_matcher #(
        .N(8),
        .VALUE1(23),
        .VALUE2(70),
        .VALUE3(117)
    ) ut (
        .value(value_in),
        .match(match)
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
    value_in = 8'b00010111; // 23
    #(5*clockPeriod) 

    // Teste 2. 
    caso = 2;
    value_in = 8'b00110000; // 48
    #(5*clockPeriod);

    // Teste 3. 
    caso = 3;
    value_in = 8'b01110101; // 117
    #(5*clockPeriod);

    // Teste 4.
    caso = 4;
    value_in = 8'b01110100; // 116
    #(5*clockPeriod);

    // Teste 5. 
    caso = 5;
    value_in = 8'b01000110; // 70
    #(5*clockPeriod);

    // Final do testbench
    caso = 99;
    $display("fim da simulacao");
    $stop;
  end

endmodule