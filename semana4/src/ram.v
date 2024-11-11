/* --------------------------------------------------------------------------
 *  Arquivo   : ram.v
 * --------------------------------------------------------------------------
 *  Descricao : Memória RAM responsável por armazenar  
 *              os bytes de um frame capturado
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autoras             
 *      20/10/2024  1.0     Bárbara Bueno       
 *                          Juliana Mitie
 *                          Tássyla Lima
 * --------------------------------------------------------------------------
 */

module ram #(parameter LINES=176, COLUMNS=288, S_DATA=8, S_LINE=8, S_COLUMN=9)
(
    input                   clk,
    input                   clear,
    input                   we,
    input  [S_DATA-1:0]     data,
    input  [S_LINE-1:0]     addr_line,
    input  [S_COLUMN-1:0]   addr_column,
    output [S_DATA-1:0]            q
);

    reg [S_DATA-1:0] ram [LINES-1:0][COLUMNS-1:0];

    reg [S_LINE:0]   addr_reg_line;
    reg [S_COLUMN:0] addr_reg_column;

    integer i, j;

    always @ (posedge clk or posedge clear)
    begin
        if (clear) begin
            for(i=0; i<LINES-1; i=i+1) begin
                for(j=0; j<COLUMNS-1; j=j+1) begin
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