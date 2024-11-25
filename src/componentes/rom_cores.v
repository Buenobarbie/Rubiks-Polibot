// ROM com 6 valores de 16 bits, contendo
// os valores RGB de 6 cores

module rom_cores
(
    input                   clk,
    input                   clear,
    input  [2:0]            addr,
    output wire  [15:0]        q
);
    reg [15:0] rom [7:0];
    initial begin
        rom[0] = 16'h4aab; // branco  0
        rom[1] = 16'h6000; // vermelho
        rom[2] = 16'he800; // laranja
        rom[3] = 16'h5343; // amarelo
        rom[4] = 16'h03e5; // verde
        rom[5] = 16'h180A; // azul
        rom[6] = 16'h0;
        rom[7] = 16'h0;
    end

    assign q = rom[addr];

endmodule

