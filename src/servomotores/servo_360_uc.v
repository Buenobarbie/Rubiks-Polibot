module servo_360_uc ( 
    input      clock       ,
    input      reset       ,
    input      iniciar     ,
    input      fim_timer   ,
    output     gira        ,
    output     conta_timer , 
    output     zera_timer  , 
    output     pronto      ,
    output reg [2:0] db_estado
);

    // Estados da UC
    parameter inicial    = 3'b000; 
    parameter preparacao = 3'b001; 
    parameter girando    = 3'b010; 
    parameter fim        = 3'b011; 

    // Variaveis de estado
    reg [2:0] Eatual, Eprox;

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
            inicial    : Eprox = iniciar ? preparacao : inicial;
            preparacao : Eprox = girando;
            girando    : Eprox = fim_timer ? fim : girando;
            fim        : Eprox = inicial;
            default    : Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        gira     = (Eatual == girando) ? 1'b1 : 1'b0;
        conta_timer = (Eatual == girando) ? 1'b1 : 1'b0;
        zera_timer  = (Eatual == preparacao) ? 1'b1 : 1'b0;
        pronto      = (Eatual == fim) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial    : db_estado = 3'b000; 
            preparacao : db_estado = 3'b001; 
            girando    : db_estado = 3'b010; 
            fim        : db_estado = 3'b011; 
            default    : db_estado = 3'b111; 
        endcase
    end
endmodule