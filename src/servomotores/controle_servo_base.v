module controle_servo_base (
    input wire clock,
    input wire reset,
    input wire [1:0] posicao,
    output wire controle,
    output wire db_reset,
    output wire [1:0] db_posicao,
    output wire db_controle
);

      circuito_pwm_3 #(           
        .conf_periodo (1000000),   // 20ms = 20ms / 20ns = 1000000 
        .largura_0    (28000  ),   // 2º 
        .largura_1    (68300  ),   // 90 
        .largura_2    (114300 )    // 180 = 114300
      ) controle_servo (
        .clock   (clock   ),
        .reset   (reset   ),
        .largura (posicao ),
        .pwm     (controle)
    );

    assign db_reset = reset;
    assign db_posicao = posicao;
    assign db_controle = controle;

endmodule
