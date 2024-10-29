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
    input wire       clock,
    input wire       reset,
    input wire       iniciar,
    input wire       VSYNC,
    input wire       HREF,
    input wire       transmite_frame, 
    input wire       transmite_byte,
    input wire       fim_coluna_quadrante,
    input wire       escreve_byte,
    output reg       byte_estavel,
    output reg       we_byte,
    output reg       zera_linha_pixel,
    output reg       zera_coluna_pixel,
    output reg       zera_linha_quadrante,
    output reg       zera_coluna_quadrante,
    output reg       conta_linha_pixel,
    output reg       conta_coluna_pixel,
    output reg       conta_linha_quadrante,
    output reg       conta_coluna_quadrante,
    output reg [3:0] db_estado 
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial         = 4'b0000;
    parameter espera_frame    = 4'b0001;
    parameter espera_linha    = 4'b0010;
    parameter atualiza_linha  = 4'b0011;
    parameter espera_byte     = 4'b0100;
    parameter le_byte         = 4'b1001;
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
            inicial:         Eprox = iniciar ? espera_frame : inicial;
            espera_frame:    Eprox = transmite_frame ? espera_linha : espera_frame;
            espera_linha:    Eprox = VSYNC ? inicial : (HREF ? atualiza_linha : espera_linha);
            atualiza_linha:  Eprox = espera_byte;
            espera_byte:     Eprox = ~HREF ? espera_linha : (transmite_byte ? le_byte : espera_byte);
            le_byte:         Eprox = (escreve_byte) ? armazena_byte : atualiza_coluna;
            armazena_byte:   Eprox = (fim_coluna_quadrante ? atualiza_linha_quadrante : atualiza_coluna_quadrante);
            atualiza_coluna: Eprox = espera_byte;
            atualiza_linha_quadrante:  Eprox = atualiza_coluna_quadrante;
            atualiza_coluna_quadrante: Eprox = atualiza_coluna;
            default:         Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        byte_estavel           = (Eatual == le_byte) ? 1'b1 : 1'b0;
        we_byte                = (Eatual == armazena_byte) ? 1'b1 : 1'b0;
        zera_linha_pixel       = (Eatual == espera_frame) ? 1'b1 : 1'b0;
        zera_coluna_pixel      = (Eatual == espera_frame ||  Eatual == atualiza_linha) ? 1'b1 : 1'b0;
        zera_linha_quadrante   = (Eatual == espera_frame) ? 1'b1 : 1'b0;
        zera_coluna_quadrante  = (Eatual == espera_frame) ? 1'b1 : 1'b0;
        conta_linha_pixel      = (Eatual == atualiza_linha) ? 1'b1 : 1'b0;
        conta_coluna_pixel     = (Eatual == atualiza_coluna) ? 1'b1 : 1'b0;
        conta_linha_quadrante  = (Eatual == atualiza_linha_quadrante) ? 1'b1 : 1'b0;
        conta_coluna_quadrante = (Eatual == atualiza_coluna_quadrante) ? 1'b1 : 1'b0;

        case (Eatual)
            inicial:         db_estado = 4'b0000;
            espera_frame:    db_estado = 4'b0001;
            espera_linha:    db_estado = 4'b0010;
            atualiza_linha:  db_estado = 4'b0011;
            espera_byte:     db_estado = 4'b0100;
            armazena_byte:   db_estado = 4'b0101;
            atualiza_coluna: db_estado = 4'b0110;
            atualiza_linha_quadrante:   db_estado = 4'b0111;
            atualiza_coluna_quadrante:  db_estado = 4'b1000;
            default:         db_estado = 4'b1001;
        endcase
    end
endmodule
