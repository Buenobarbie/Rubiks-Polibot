module gerenciador_servos (
    input clock,
    input reset,
    input ativa_peteleco,
    input ativa_tampa,
    input ativa_base,        
    output wire  pronto,
    output wire  pwm,
    output wire [2:0] db_estado
);

    wire s_zera_servo_peteleco;
    wire s_zera_servo_tampa;
    wire s_zera_servo_base;
    wire s_move_servo_peteleco;
    wire s_move_servo_tampa;
    wire s_move_servo_base;
    wire s_conta_servo_peteleco;
    wire s_conta_servo_tampa;
    wire s_conta_servo_base;
    wire s_fim_servo_peteleco;
    wire s_fim_servo_tampa;
    wire s_fim_servo_base;
    wire s_shifta_servo_tampa;
    wire s_gira;
    
    gerenciador_servos_uc UC (
        .clock   (clock),
        .reset   (reset),
        .move_servo_peteleco (s_move_servo_peteleco),
        .move_servo_tampa    (s_move_servo_tampa),
        .move_servo_base     (s_move_servo_base),
        .fim_servo_peteleco  (s_fim_servo_peteleco),
        .fim_servo_tampa     (s_fim_servo_tampa),
        .fim_servo_base      (s_fim_servo_base),
        .zera_servo_peteleco (s_zera_servo_peteleco),
        .zera_servo_tampa    (s_zera_servo_tampa),
        .zera_servo_base     (s_zera_servo_base),
        .conta_servo_peteleco (s_conta_servo_peteleco),
        .conta_servo_tampa    (s_conta_servo_tampa),
        .conta_servo_base     (s_conta_servo_base),
        .gira                 (s_gira),
        .shifta_servo_tampa   (s_shifta_servo_tampa),
        .shifta_servo_base    (s_shifta_servo_base),
        .pronto               (pronto),
        .db_estado            (db_estado)
    );

    gerenciador_servos_fd FD (
        .clock      (clock),
        .reset      (reset),
        .ativa_peteleco (ativa_peteleco ),
        .ativa_tampa    (ativa_tampa    ),
        .ativa_base     (ativa_base     ),
        .zera_servo_peteleco (s_zera_servo_peteleco),
        .zera_servo_tampa    (s_zera_servo_tampa),
        .zera_servo_base     (s_zera_servo_base),
        .conta_servo_peteleco (s_conta_servo_peteleco),
        .conta_servo_tampa    (s_conta_servo_tampa),
        .conta_servo_base     (s_conta_servo_base),
        .gira                 (s_gira),
        .shifta_servo_tampa   (s_shifta_servo_tampa),
        .shifta_servo_base    (s_shifta_servo_base),
        .fim_servo_peteleco  (s_fim_servo_peteleco),
        .fim_servo_tampa     (s_fim_servo_tampa),
        .fim_servo_base      (s_fim_servo_base),
        .pwm                 (pwm),
        .move_servo_peteleco (s_move_servo_peteleco),
        .move_servo_tampa    (s_move_servo_tampa),
        .move_servo_base     (s_move_servo_base),
    );

endmodule