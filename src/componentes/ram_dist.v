// Modulo de ram com 6 valores, que permite
// a escrita de um valor e a leitura dos 6 valores 
// ao mesmo tempo
// Os valores são de 13 bits fixo

module ram_dist
(
    input                   clk,
    input                   clear,
    input                   we,
    input  [12:0]           data,
    input  [2:0]            addr,
    output [12:0]           q0,
    output [12:0]            q1,
    output [12:0]            q2,
    output [12:0]            q3,
    output [12:0]            q4,
    output [12:0]            q5
);

    reg [12:0] ram [5:0];

    reg [2:0]   addr_reg;

    integer i;

    always @ (posedge clk or posedge clear)
    begin
        if (clear) begin
            for(i=0; i<5; i=i+1) begin
                ram[i] <= 0;
            end
        end

        else if (we) begin
            ram[addr_reg] <= data;
        end
        
        else begin
            addr_reg <= addr;
        end

    end

    assign q0 = ram[0];
    assign q1 = ram[1];
    assign q2 = ram[2];
    assign q3 = ram[3];
    assign q4 = ram[4];
    assign q5 = ram[5];

endmodule
