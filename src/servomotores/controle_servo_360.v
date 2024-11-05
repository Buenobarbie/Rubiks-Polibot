module controle_servo_360 (
    input wire clock,
    input wire reset,
    input wire [1:0] posicao,
    output wire controle,
    output wire db_reset,
    output wire [1:0] db_posicao,
    output wire db_controle
);

      // 50.000 -> 0°
      // 100.000 -> 180°

      circuito_pwm #(           
        .conf_periodo (1000000), // 20ms = 20ms / 2ns = 1000000 
        .largura_00  (50000),   // 0°  => (100.000-50.000)/180° * 20° + 50.000 = 55.556
        .largura_01  (75000),   // 90° => (100.000-50.000)/180° * 90° + 50.000 = 61.111
        .largura_10  (100000)   // 180° => (100.000-50.000)/180° * 60° + 50.000 = 66.667
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
