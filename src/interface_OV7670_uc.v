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
    output reg      PWDN,
    output reg      write_en,
    output reg      zera_linha,
    output reg      zera_coluna,
    output reg      conta_linha,
    output reg      conta_coluna,
    output reg [3:0] db_estado 
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; // 3 bits são suficientes para 7 estados

    // Parâmetros para os estados
    parameter inicial         = 3'b000;
    parameter espera_frame    = 3'b001;
    parameter espera_linha    = 3'b010;
    parameter atualiza_linha  = 3'b011;
    parameter espera_byte     = 3'b100;
    parameter armazena_byte   = 3'b101;
    parameter atualiza_coluna = 3'b110;
    
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
            espera_byte:     Eprox = ~HREF ? espera_linha : (transmite_byte ? armazena_byte : espera_byte);
            armazena_byte:   Eprox = atualiza_coluna;
            atualiza_coluna: Eprox = espera_byte;
            default:         Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        PWDN         = (Eatual == inicial) ? 1'b1 : 1'b0;
        zera_linha   = (Eatual == espera_frame) ? 1'b1 : 1'b0;
        zera_coluna  = (Eatual == espera_frame ||  Eatual == atualiza_linha) ? 1'b1 : 1'b0;
        conta_linha  = (Eatual == atualiza_linha) ? 1'b1 : 1'b0;
        conta_coluna = (Eatual == atualiza_coluna) ? 1'b1 : 1'b0;
        write_en     = (Eatual == armazena_byte) ? 1'b1 : 1'b0;

        case (Eatual)
            inicial:         db_estado = 4'b0000;
            espera_frame:    db_estado = 4'b0001;
            espera_linha:    db_estado = 4'b0010;
            atualiza_linha:  db_estado = 4'b0011;
            espera_byte:     db_estado = 4'b0100;
            armazena_byte:   db_estado = 4'b0101;
            atualiza_coluna: db_estado = 4'b1111;
            default:         db_estado = 4'b1110;
        endcase
    end
endmodule
