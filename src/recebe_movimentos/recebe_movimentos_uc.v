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
 
module recebe_movimentos_uc (
    input wire clock,
    input wire reset,
    input wire iniciar,
    input wire fim_transmissao,
    input wire fim_recepcao,
    input wire fim_movimentos,
    output reg zera_addr,
    output reg partida_serial,
    output reg we_movimento, 
    output reg conta_addr,
    output reg pronto,
    output reg [2:0] db_estado
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial             = 3'b000;
    parameter preparacao          = 3'b001;
    parameter transmite_serial    = 3'b010;
    parameter recebe_serial       = 3'b011;
    parameter armazena_movimento  = 3'b100;
    parameter atualiza_addr       = 3'b101; 
    parameter fim                 = 3'b110; 

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
            inicial:            Eprox = iniciar ? preparacao : inicial;
            preparacao:         Eprox = transmite_serial;
            transmite_serial:   Eprox = fim_transmissao ? recebe_serial : transmite_serial;
            recebe_serial:      Eprox = fim_recepcao ? armazena_movimento : recebe_serial;
            armazena_movimento: Eprox = atualiza_addr; 
            atualiza_addr:      Eprox = fim_movimentos ? fim : recebe_serial;
            fim:                Eprox = inicial;
            default:            Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        zera_addr      = (Eatual == preparacao);
        partida_serial = (Eatual == preparacao);
        we_movimento   = (Eatual == armazena_movimento);
        conta_addr     = (Eatual == atualiza_addr);
        pronto         = (Eatual == fim);

        case (Eatual)
            inicial:                   db_estado = 3'b000;
            preparacao:                db_estado = 3'b001;
            transmite_serial:          db_estado = 3'b010;
            recebe_serial:             db_estado = 3'b011;
            armazena_movimento:        db_estado = 3'b100;
            atualiza_addr:             db_estado = 3'b101;
            fim:                       db_estado = 3'b110;
            default:                   db_estado = 3'b111;
        endcase
    end
endmodule
