// ram com 480 valores de 3 bits, os primeors 8
// valores são pre definidos e os demais zerados

module ram_movimentos (
    input                  clk,
    input                  clear,
    input                  we,
    input  [2:0]           data,
    input  [8:0]           addr,
    output wire  [2:0]     q
);

    // ram 480 com valores de 3 bits
    reg [2:0] ram [479:0];
    
    // quanto resetar, voltar para os valores predefinidos
    reg [8:0] addr_reg;
    integer i;
    always @ (posedge clk or posedge clear)
    begin 
        if(clear) begin
            ram[0] = 3'b000;
            ram[1] = 3'b001;
            ram[2] = 3'b010;
            ram[3] = 3'b011;
            ram[4] = 3'b100;
            ram[5] = 3'b101;
            ram[6] = 3'b110;
            ram[7] = 3'b111;

            for(i=8; i<480; i=i+1) begin
                ram[i] = 3'b000;
            end
        end
        else if(we) begin
            ram[addr_reg] <= data;
        end
        else begin
            addr_reg <= addr;
        end

    end

    assign q = ram[addr];

endmodule

