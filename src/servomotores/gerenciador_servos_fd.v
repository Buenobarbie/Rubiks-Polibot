 module gerenciador_servos_fd (
    input wire clock,
    input wire reset,
    input wire ativa_peteleco, 
    input wire ativa_tampa, 
    input wire ativa_base, 
    input wire zera_servo_peteleco,
    input wire zera_servo_tampa,
    input wire zera_servo_base,
    input wire conta_servo_peteleco,
    input wire conta_servo_tampa,
    input wire conta_servo_base,
    input wire gira,
    input wire shifta_servo_tampa, 
    input wire shifta_servo_base,
    output wire fim_servo_peteleco,
    output wire fim_servo_tampa,
    output wire fim_servo_base,
    output wire pwm,
    output wire move_servo_peteleco,
    output wire move_servo_tampa,
    output wire move_servo_base

);

    wire s_posicao_tampa;
    wire s_posicao_base;


// ########## SERVOS ##########

    controle_servo_360 servo_peteleco (
        .clock       (clock),
        .reset       (reset),
        .posicao     (gira ),
        .controle    (pwm  ),
        .db_reset    (  ),
        .db_posicao  (  ),
        .db_controle (  )
    );

    controle_servo1_180 servo_tampa (
        .clock       (clock),
        .reset       (reset),
        .posicao     (s_posicao_tampa),
        .controle    (pwm  ),
        .db_reset    (  ),
        .db_posicao  (  ),
        .db_controle (  )
    );

    controle_servo2_180 servo_base (
        .clock       (clock),
        .reset       (reset),
        .posicao     (s_posicao_base),
        .controle    (pwm  ),
        .db_reset    (  ),
        .db_posicao  (  ),
        .db_controle (  )
    );

// ########## CONTADORES ##########

    contador_m #(
        .M(50000000),
        .N(26)
    ) contador_servo_peteleco (
        .clock   (clock),
        .zera_as (zera_servo_peteleco ),
        .zera_s  (zera_servo_peteleco ),
        .conta   (conta_servo_peteleco),
        .Q       (  ),  
        .fim     (fim_servo_peteleco  ),
        .meio    (  )  
    );

    contador_m #(
        .M(50000000),
        .N(26)
    ) contador_servo_tampa (
        .clock   (clock),
        .zera_as (zera_servo_tampa ),
        .zera_s  (zera_servo_tampa ),
        .conta   (conta_servo_tampa),
        .Q       (  ),  
        .fim     (fim_servo_tampa  ),
        .meio    (  )  
    );

    contador_m #(
        .M(50000000),
        .N(26)
    ) contador_servo_base (
        .clock   (clock),
        .zera_as (zera_servo_base ),
        .zera_s  (zera_servo_base ),
        .conta   (conta_servo_base),
        .Q       (  ),  
        .fim     (fim_servo_base  ),
        .meio    (  )  
    );

// ########## FLIP-FLOPS-T ##########

    flip_flopT flipa_tampa (
        .clk   (clock),
        .clear (reset ),
        .t     (shifta_servo_tampa),
        .q     (s_posicao_tampa)
    );

    flip_flopT flipa_base (
        .clk   (clock),
        .clear (reset ),
        .t     (shifta_servo_tampa),
        .q     (s_posicao_base)
    );

// ########## EDGE-DETECTORS ##########

    edge_detector edge_peteleco (
            .clock  (clock),
            .reset  (reset),
            .sinal  (ativa_peteleco),
            .pulso  (move_servo_peteleco)
        );

    edge_detector edge_tampa (
            .clock  (clock),
            .reset  (reset),
            .sinal  (ativa_tampa),
            .pulso  (move_servo_tampa)
        );

    edge_detector edge_base (
            .clock  (clock),
            .reset  (reset),
            .sinal  (ativa_base),
            .pulso  (move_servo_base)
        );

endmodule
