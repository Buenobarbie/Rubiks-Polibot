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
 
module indentifica_cores_uc (
    input wire       clock,
    input wire       reset,
    input wire       iniciar,
    input wire       fim_cor,
    input wire       fim_coluna,
    input wire       fim_linha,
    output reg       zera_linha,
    output reg       zera_coluna,
    output reg       zera_cor,
    output reg       conta_cor,
    output reg       conta_linha,
    output reg       conta_coluna,
    output reg       we_cor,
    output reg       we_dist,
    output reg       pronto,
    output reg [3:0] db_estado 
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial             = 4'b0000;
    parameter prepara             = 4'b0001;
    parameter calcula_diferenca   = 4'b0010;
    parameter obtem_quadrado      = 4'b0011;
    parameter soma_diferencas     = 4'b0100;
    parameter armazena_distancia  = 4'b0101;
    parameter atualiza_cor        = 4'b0110;
    parameter compara_distancias  = 4'b0111;
    parameter define_cor          = 4'b1000;
    parameter armazena_cor        = 4'b1001;
    parameter atualiza_linha      = 4'b1010;
    parameter atualiza_coluna     = 4'b1011;
    parameter fim                 = 4'b1100;
    
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
            inicial:         Eprox = iniciar ? prepara : inicial;
            prepara:         Eprox = calcula_diferenca;
            calcula_diferenca:   Eprox = obtem_quadrado;
            obtem_quadrado:      Eprox = soma_diferencas;
            soma_diferencas:     Eprox = armazena_distancia;
            armazena_distancia:  Eprox = atualiza_cor;
            atualiza_cor:        Eprox = (fim_cor)? compara_distancias : calcula_diferenca;
            compara_distancias:  Eprox = define_cor;
            define_cor:          Eprox = armazena_cor;
            armazena_cor:        Eprox = (~fim_coluna)? atualiza_coluna : (fim_linha)? fim : atualiza_coluna;
            atualiza_linha:      Eprox = atualiza_coluna;
            atualiza_coluna:     Eprox = prepara;
            fim:                 Eprox = inicial;

            default:         Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        zera_linha = (Eatual == inicial);
        zera_coluna = (Eatual == inicial);
        zera_cor = (Eatual == inicial || Eatual == prepara);
        conta_cor = (Eatual == atualiza_cor);
        conta_linha = (Eatual == atualiza_linha);
        conta_coluna = (Eatual == atualiza_coluna);
        pronto = (Eatual == fim);
        we_cor = (Eatual == armazena_cor);
        we_dist = (Eatual == armazena_distancia);

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
