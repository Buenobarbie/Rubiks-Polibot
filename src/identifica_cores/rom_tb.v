// ROM com 6 valores de 16 bits, contendo
// os valores RGB de 6 cores

module rom_tb
(
    input                   clk,
    input                   clear,
    input  [1:0]            addr1,
    input  [1:0]            addr2,
    output wire  [15:0]        q
);
    // rom 3x3 com valores de 16 bits
    reg [15:0] rom [3:0][3:0];
    initial begin
        rom[0][0] = 16'h5E0B; // branco
        rom[0][1] = 16'h4801; // vermelho
        rom[0][2] = 16'hC101; // laranja
        rom[1][0] = 16'h86C1; // amarelo
        rom[1][1] = 16'h1E03; // verde
        rom[1][2] = 16'h12A9; // azul
        rom[2][0] = 16'h5E0B; // branco
        rom[2][1] = 16'h4801; // vermelho
        rom[2][2] = 16'hC101; // laranja
        
    end

    assign q = rom[addr1][addr2];

endmodule

