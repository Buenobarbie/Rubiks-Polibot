/* --------------------------------------------------------------------------
 *  Arquivo   : ram2.v
 * --------------------------------------------------------------------------
 *  Descricao : Memória RAM populada para testes  
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autoras             
 *      20/10/2024  1.0     Bárbara Bueno       
 *                          Juliana Mitie
 *                          Tássyla Lima
 * --------------------------------------------------------------------------
 */

module ram2 (
    input            clk,
    input            clear,
    input            we,
    input  [15:0]    data,
    input  [1:0]     addr_line,
    input  [1-1:0]   addr_column,
    output [15:0]    q
);

    reg [15:0] ram [2:0][2:0];

    reg [1:0] addr_reg_line;
    reg [1:0] addr_reg_column;

    initial begin
        // Linha 0
        ram[0][0] = 16'hAAAA;
        ram[0][1] = 16'hBBBB;
        ram[0][2] = 16'hCCCC;

        // Linha 1
        ram[1][0] = 16'hDDDD;
        ram[1][1] = 16'hEEEE;
        ram[1][2] = 16'hFFFF;

        // Linha 2
        ram[2][0] = 16'h1111;
        ram[2][1] = 16'h2222;
        ram[2][2] = 16'h3333;
    end


    integer i, j;

    always @ (posedge clk or posedge clear)
    begin
        if (clear) begin
            for(i=0; i<2; i=i+1) begin
                for(j=0; j<2; j=j+1) begin
                    ram[i][j] <= 0;
                end
            end
        end

        else if (we) begin
            ram[addr_reg_line][addr_reg_column] <= data;
        end
        
        else begin
            addr_reg_line <= addr_line;
            addr_reg_column <= addr_column;
        end

    end

    assign q = ram[addr_reg_line][addr_reg_column];

endmodule