// ram com 9 valores de 16 bits

module ram_3x3 #(parameter S_DATA=16)
(
    input                   clk,
    input                   clear,
    input                   we,
    input  [S_DATA-1:0]           data,
    input  [1:0]            addr1,
    input  [1:0]            addr2,
    output wire  [15:0]        q
);
    // ram 3x3 com valores de S_DATA bits
    reg [S_DATA-1:0] ram [3:0][3:0];

    reg [1:0]   addr1_reg;
    reg [1:0]   addr2_reg;

    integer i,j;
    always @ (posedge clk or posedge clear)
    begin
        if (clear) begin
            for(i=0; i<3; i=i+1) begin
                for(j=0; j<3; j=j+1) begin
                    ram[i][j] <= 0;
                end
            end
        end

        else if (we) begin
            ram[addr1_reg][addr2_reg] <= data;
        end
        
        else begin
            addr1_reg <= addr1;
            addr2_reg <= addr2;
        end

    end



    assign q = ram[addr1][addr2];

endmodule

