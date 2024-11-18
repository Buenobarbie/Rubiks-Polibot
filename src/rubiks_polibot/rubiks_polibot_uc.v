
module interface_OV7670_uc (
    input wire clock,
    input wire reset,
    input wire iniciar,
    input wire imagem_recebida,
    input wire cores_identificadas,
    input wire cores_transmitidas,
    input wire fim_face,
    input wire fim_movimento,
    input wire movimento_par,
    input wire meio_face,
    input wire movimentos_recebidos,
    input wire fim_rom,
    output reg zera_face,
    output reg zera_movimento,
    output reg captura_imagem,
    output reg identificar_cores,
    output reg enviar_cores,
    output reg aciona_movimento,
    output reg conta_movimento,
    output reg conta_face,
    output reg pronto,
    output reg [3:0] db_estado

);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox; 

    // Parâmetros para os estados
    parameter inicial                 = 4'b0000;
    parameter prepara                 = 4'b0001;
    parameter recebe_imagem           = 4'b0010;
    parameter identifica_cores        = 4'b0011;
    parameter transmite_cores         = 4'b0100;
    parameter muda_face               = 4'b0101;
    parameter atualiza_movimento_face = 4'b0110;
    parameter atualiza_face           = 4'b0111;
    parameter recebe_movimentos       = 4'b1000;
    parameter prepara_movimentos      = 4'b1001;
    parameter movimenta               = 4'b1010;
    parameter atualiza_movimento      = 4'b1011;
    parameter fim                     = 4'b1100;
    
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
            prepara:         Eprox = recebe_imagem;
            recebe_imagem:   Eprox = (imagem_recebida) ? identifica_cores : recebe_imagem;
            identifica_cores:Eprox = (cores_identificadas) ? transmite_cores : identifica_cores;
            transmite_cores: Eprox = (~cores_transmitidas) ? transmite_cores : (fim_face) ? recebe_movimentos : muda_face;
            muda_face:      Eprox = (fim_movimento) ? atualiza_movimento_face : muda_face;
            atualiza_movimento_face: Eprox = (~meio_face) ? atualiza_face : (movimento_par) ? muda_face : atualiza_movimento_face;
            atualiza_face:  Eprox = recebe_imagem;
            recebe_movimentos: Eprox = (movimentos_recebidos) ? prepara_movimentos : recebe_movimentos;
            prepara_movimentos: Eprox = movimenta;
            movimenta:      Eprox = (fim_movimento) ? atualiza_movimento : movimenta;
            atualiza_movimento: Eprox = (fim_rom) ? fim : movimenta;
        

            default:         Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        zera_face = (Eatual == prepara);
        zera_movimento = (Eatual == prepara || Eatual == prepara_movimentos);
        captura_imagem = (Eatual == recebe_imagem);
        identificar_cores = (Eatual == identifica_cores);
        enviar_cores = (Eatual == transmite_cores);
        aciona_movimento = (Eatual == muda_face || Eatual == movimenta);
        conta_movimento = (Eatual == atualiza_movimento_face || Eatual == atualiza_movimento);
        conta_face = (Eatual == atualiza_face);
        pronto = (Eatual == fim);



        case (Eatual)
            inicial:         db_estado = 4'b0000;
            prepara:         db_estado = 4'b0001;
            recebe_imagem:   db_estado = 4'b0010;
            identifica_cores:db_estado = 4'b0011;
            transmite_cores: db_estado = 4'b0100;
            muda_face:       db_estado = 4'b0101;
            atualiza_movimento_face: db_estado = 4'b0110;
            atualiza_face:   db_estado = 4'b0111;
            recebe_movimentos: db_estado = 4'b1000;
            prepara_movimentos: db_estado = 4'b1001;
            movimenta:       db_estado = 4'b1010;
            atualiza_movimento: db_estado = 4'b1011;
            fim:             db_estado = 4'b1100;


            default:         db_estado = 4'b1111;
        endcase
    end
endmodule
