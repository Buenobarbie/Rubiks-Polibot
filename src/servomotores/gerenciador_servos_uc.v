module gerenciador_servos_uc ( 
    input clock,
    input reset,
    input move_servo_peteleco,
    input move_servo_tampa,
    input move_servo_base,
    input fim_servo_peteleco,
    input fim_servo_tampa,
    input fim_servo_base,
    output reg zera_servo_peteleco,
    output reg zera_servo_tampa,
    output reg zera_servo_base,
    output reg conta_servo_peteleco,
    output reg conta_servo_tampa,
    output reg conta_servo_base,
    output reg gira,
    output reg shifta_servo_tampa,
    output reg we_registrador,
    output reg pronto,
    output reg [2:0] db_estado
);

    // Estados da UC
    parameter inicial             = 3'b000; 
    parameter gira_servo_peteleco = 3'b001; 
    parameter gira_servo_tampa    = 3'b010; 
    parameter gira_servo_base     = 3'b011; 
    parameter timer_servo_tampa   = 3'b100; 
    parameter timer_servo_base    = 3'b101; 
    parameter fim                 = 3'b110;

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
            inicial             : Eprox = move_servo_peteleco ? gira_servo_peteleco : (move_servo_tampa ? gira_servo_tampa : (move_servo_base ? gira_servo_base : inicial));
            gira_servo_peteleco : Eprox = fim_servo_peteleco ? fim : gira_servo_peteleco;
            gira_servo_tampa    : Eprox = timer_servo_tampa;
            gira_servo_base     : Eprox = timer_servo_base;
            timer_servo_tampa   : Eprox = fim_servo_tampa ? fim : timer_servo_tampa;
            timer_servo_base    : Eprox = fim_servo_base ? fim : timer_servo_base;
            fim                 : Eprox = inicial;
            default : Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        zera_servo_peteleco  = (Eatual == inicial) ? 1'b1 : 1'b0;
        zera_servo_tampa     = (Eatual == inicial) ? 1'b1 : 1'b0;
        zera_servo_base      = (Eatual == inicial) ? 1'b1 : 1'b0;
        conta_servo_peteleco = (Eatual == gira_servo_peteleco) ? 1'b1 : 1'b0;
        conta_servo_tampa    = (Eatual == timer_servo_tampa)   ? 1'b1 : 1'b0;
        conta_servo_base     = (Eatual == timer_servo_base)    ? 1'b1 : 1'b0;
        shifta_servo_tampa   = (Eatual == gira_servo_tampa) ? 1'b1 : 1'b0;
        we_registrador       = (Eatual == gira_servo_base) ? 1'b1 : 1'b0;
        gira        = (Eatual == gira_servo_peteleco) ? 1'b1 : 1'b0;
        pronto      = (Eatual == fim) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial             : db_estado = 3'b000; 
            gira_servo_peteleco : db_estado = 3'b001; 
            gira_servo_tampa    : db_estado = 3'b010; 
            gira_servo_base     : db_estado = 3'b011; 
            timer_servo_tampa   : db_estado = 3'b100;
            timer_servo_base    : db_estado = 3'b101;
            fim                 : db_estado = 3'b110; 
            default    : db_estado = 3'b111; 
        endcase
    end
endmodule