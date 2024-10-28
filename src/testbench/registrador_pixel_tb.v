/* --------------------------------------------------------------------
 * Arquivo   : registrador_pixel_tb.v
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog do modulo registrador_pixel
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

module registrador_pixel_tb;

  // Input signals
  reg         clock_in;
  reg         clear_in;
  reg         enable_in;
  reg  [7:0]  D_in;

  // Output signals
  wire [15:0] Q_out;

  // Component to be tested (Device Under Test -- DUT)
    registrador_pixel ut (
        .clock  (clock_in),
        .clear  (clear_in),
        .enable (enable_in),
        .D      (D_in),
        .Q      (Q_out)
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

    // Teste 1.  Reset
    caso = 1;
    clear_in = 1;
    enable_in = 0;
    D_in = 8'b0;
    @(negedge clock_in); // espera borda de descida
    clear_in = 0;

    // Teste 2.  
    caso = 2;
    D_in = 8'b10101010;
    #(5*clockPeriod);

    enable_in = 1;
    #(clockPeriod);
    enable_in = 0;
    #(5*clockPeriod);

    // Teste 3.
    caso = 3;
    D_in = 8'b11001100;
    enable_in = 1;
    #(clockPeriod);
    enable_in = 0;
    #(5*clockPeriod);

    // Teste 4.
    caso = 4;
    D_in = 8'b11110000;
    enable_in = 1;
    #(clockPeriod);
    enable_in = 0;
    #(5*clockPeriod);

    // Teste 5.
    caso = 5;
    D_in = 8'b00001111;
    enable_in = 1;
    #(clockPeriod);
    enable_in = 0;
    #(5*clockPeriod);



    // Final do testbench
    caso = 99;
    $display("fim da simulacao");
    $stop;
  end

endmodule