module transmissao_serial_uc ( 
    input      clock       ,
    input      reset       ,
    input      iniciar     ,
    input      pronto      ,
    input      fim_linha   , 
    input      fim_coluna  ,
    output reg partida_serial, 
    output reg conta_linha   , 
    output reg conta_coluna , 
    output reg zera_linha    ,
    output reg zera_coluna   ,
    output reg [3:0] db_estado
);

    // Estados da UC
    parameter inicial            = 4'b0000; 
    parameter preparacao         = 4'b0001; 
    parameter transmissao_serial = 4'b0010; 
    parameter espera_serial      = 4'b0011; 
    parameter conta_coluna_pixel = 4'b0101; 
    parameter conta_linha_pixel  = 4'b0110; 

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial            : Eprox = iniciar ? preparacao : inicial;
            preparacao         : Eprox = transmissao_serial;
            transmissao_serial : Eprox = espera_serial;
            espera_serial      : Eprox = ~pronto ? espera_serial : conta_coluna_pixel ;
            conta_coluna_pixel : Eprox = fim_coluna ? conta_linha_pixel : transmissao_serial;
            conta_linha_pixel  : Eprox = fim_linha ? inicial : transmissao_serial;
            default            : Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        zera_coluna    = (Eatual == preparacao) ? 1'b1 : 1'b0;
        zera_linha     = (Eatual == preparacao) ? 1'b1 : 1'b0;
        conta_coluna   = (Eatual == conta_coluna_pixel) ? 1'b1 : 1'b0;
        conta_linha    = (Eatual == conta_linha_pixel) ? 1'b1 : 1'b0;
        partida_serial = (Eatual == transmissao_serial) ? 1'b1 : 1'b0;
       
        // Saida de depuracao (estado)
        case (Eatual)
            inicial            : db_estado = 4'b0000; 
            preparacao         : db_estado = 4'b0001; 
            transmissao_serial : db_estado = 4'b0010; 
            espera_serial      : db_estado = 4'b0011; 
            conta_coluna_pixel : db_estado = 4'b0101;
            conta_linha_pixel  : db_estado = 4'b0110;
            default            : db_estado = 4'b1110; 
        endcase
    end
endmodule