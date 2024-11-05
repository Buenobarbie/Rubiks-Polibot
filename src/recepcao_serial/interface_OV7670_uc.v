/* --------------------------------------------------------------------------
 *  Arquivo   : interface_OV7670_uc.v
 * --------------------------------------------------------------------------
 *  Descricao : Código da unidade de controle da interface do 
                sensor OV7670 para a captura e transmissao 
                dos bytes de informacao das imagens
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autoras             
 *      20/10/2024  1.0     Bárbara Bueno       
 *                          Juliana Mitie
 *                          Tássyla Lima
 * --------------------------------------------------------------------------
 */
 
module interface_OV7670_uc (
    input wire clock,
    input wire reset,
    input wire iniciar,
    input wire fim_transmissao,
    input wire fim_recepcao,
    input wire escreve_byte,
    input wire fim_coluna_quadrante,
    output wire zera_linha,
    output wire zera_coluna,
    output wire zera_linha_quadrante,
    output wire zera_coluna_quadrante,
    output wire we_byte,
    output wire conta_linha_quadrante,
    output wire conta_coluna_quadrante,
    output wire conta_coluna_pixel,
    output wire partida_serial,
    output reg [3:0] db_estado
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial             = 4'b0000;
    parameter captura             = 4'b0001;
    parameter transmite_serial    = 4'b0010;
    parameter recebe_serial       = 4'b0011;
    parameter le_byte             = 4'b0100;
    parameter armazena_byte   = 4'b0101;
    parameter atualiza_coluna = 4'b0110;
    parameter atualiza_linha_quadrante  = 4'b0111;
    parameter atualiza_coluna_quadrante = 4'b1000;
    
    // Estado
    always @(posedge clock, posedge reset) begin
        if (reset) 
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial:         Eprox = iniciar ? captura : inicial;
            captura:         Eprox = transmite_serial;
            transmite_serial:Eprox = fim_transmissao ? recebe_serial : transmite_serial;
            recebe_serial:   Eprox = fim_recepcao ? le_byte : recebe_serial;
            le_byte:         Eprox = (escreve_byte) ? armazena_byte : atualiza_coluna;
            armazena_byte:   Eprox = (fim_coluna_quadrante ? atualiza_linha_quadrante : atualiza_coluna_quadrante);
            atualiza_coluna: Eprox = recebe_serial;
            atualiza_linha_quadrante:  Eprox = atualiza_coluna_quadrante;
            atualiza_coluna_quadrante: Eprox = atualiza_coluna;
            default:         Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        zera_linha              = (Eatual == captura);
        zera_coluna             = (Eatual == captura);
        zera_linha_quadrante    = (Eatual == captura);
        zera_coluna_quadrante   = (Eatual == captura);
        we_byte                 = (Eatual == armazena_byte);
        conta_linha_quadrante   = (Eatual == atualiza_linha_quadrante);
        conta_coluna_quadrante  = (Eatual == atualiza_coluna_quadrante);
        conta_coluna_pixel      = (Eatual == atualiza_coluna);
        partida_serial          = (Eatual == captura);



        case (Eatual)
            inicial:         db_estado = 4'b0000;
            captura:         db_estado = 4'b0001;
            transmite_serial:db_estado = 4'b0010;
            recebe_serial:   db_estado = 4'b0011;
            le_byte:         db_estado = 4'b0100;
            armazena_byte:   db_estado = 4'b0101;
            atualiza_coluna: db_estado = 4'b0110;
            atualiza_linha_quadrante:  db_estado = 4'b0111;
            atualiza_coluna_quadrante: db_estado = 4'b1000;

            default:         db_estado = 4'b1001;
        endcase
    end
endmodule
