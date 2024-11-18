// ROM com 6 valores de 16 bits, contendo
// os valores RGB de 6 cores

module rom_cores
(
    input                   clk,
    input                   clear,
    input  [2:0]            addr,
    output wire  [15:0]        q
);
    reg [15:0] rom [5:0];
    initial begin
        rom[0] = 16'h5E0B; // branco
        rom[1] = 16'h4801; // vermelho
        rom[2] = 16'hC101; // laranja
        rom[3] = 16'h86C1; // amarelo
        rom[4] = 16'h1E03; // verde
        rom[5] = 16'h12A9; // azul
    end

    assign q = rom[addr];

endmodule

