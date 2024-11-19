module gerenciador_servos (
    input clock,
    input reset,
    input iniciar,
    input [2:0]  move,
    output wire  pronto,
    output wire  pwm_peteleco,
	output wire  pwm_tampa,
	output wire  pwm_base //,
    //output wire [2:0] db_estado
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
    wire s_we_registrador;
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
        .we_registrador       (s_we_registrador),
        .pronto               (pronto) //,
        //.db_estado          (db_estado)
    );

    gerenciador_servos_fd FD (
        .clock          (clock),
        .reset          (reset),
        .move           (move),
        .zera_servo_peteleco (s_zera_servo_peteleco),
        .zera_servo_tampa    (s_zera_servo_tampa),
        .zera_servo_base     (s_zera_servo_base),
        .conta_servo_peteleco (s_conta_servo_peteleco),
        .conta_servo_tampa    (s_conta_servo_tampa),
        .conta_servo_base     (s_conta_servo_base),
        .gira                 (s_gira),
        .shifta_servo_tampa   (s_shifta_servo_tampa),
        .we_registrador       (s_we_registrador),
        .fim_servo_peteleco  (s_fim_servo_peteleco),
        .fim_servo_tampa     (s_fim_servo_tampa),
        .fim_servo_base      (s_fim_servo_base),
        .pwm_peteleco        (pwm_peteleco),
		.pwm_tampa           (pwm_tampa),
		.pwm_base            (pwm_base),
        .move_servo_peteleco (s_move_servo_peteleco),
        .move_servo_tampa    (s_move_servo_tampa),
        .move_servo_base     (s_move_servo_base)
    );

endmodule