 module gerenciador_servos_fd (
    input wire clock,
    input wire reset,
    input wire [2:0] move,
    input wire zera_servo_peteleco,
    input wire zera_servo_tampa,
    input wire zera_servo_base,
    input wire conta_servo_peteleco,
    input wire conta_servo_tampa,
    input wire conta_servo_base,
    input wire gira,
    input wire shifta_servo_tampa,
    input wire we_registrador,
    output wire fim_servo_peteleco,
    output wire fim_servo_tampa,
    output wire fim_servo_base,
    output wire pwm_peteleco,
	output wire pwm_tampa,
	output wire pwm_base,
    output wire move_servo_peteleco,
    output wire move_servo_tampa,
    output wire move_servo_base

);

    wire s_posicao_tampa;
    wire [1:0] s_posicao_base;

// ########## SERVOS ##########

    controle_servo_peteleco servo_peteleco (
        .clock       (clock),
        .reset       (reset),
        .posicao     (gira ),
        .controle    (pwm_peteleco  ),
        .db_reset    (  ),
        .db_posicao  (  ),
        .db_controle (  )
    );

    controle_servo_tampa servo_tampa (
        .clock       (clock),
        .reset       (reset),
        .posicao     (s_posicao_tampa),
        .controle    (pwm_tampa  ),
        .db_reset    (  ),
        .db_posicao  (  ),
        .db_controle (  )
    );

    controle_servo_base servo_base (
        .clock       (clock),
        .reset       (reset),
        .posicao     (s_posicao_base),
        .controle    (pwm_base  ),
        .db_reset    (  ),
        .db_posicao  (  ),
        .db_controle (  )
    );

// ########## CONTADORES ##########

    contador_m #(
        .M(42000000),
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

// ########## FLIP-FLOP-T ##########

    flip_flopT flipa_tampa (
        .clk   (clock),
        .clear (reset ),
        .t     (shifta_servo_tampa),
        .q     (s_posicao_tampa)
    );

// ########## SERVO-MATCHER ##########

    servo_matcher matcher (
        .move     (move),
        .peteleco (move_servo_peteleco),
        .tampa    (move_servo_tampa),
        .base     (move_servo_base)
    );

// ########## REGISTRADOR 3-BITS ##########

    registrador_3bits reg3 (
        .clock (clock),
        .clear (reset),
        .enable(we_registrador),
        .D(move),
        .Q(s_posicao_base)
    );

endmodule
