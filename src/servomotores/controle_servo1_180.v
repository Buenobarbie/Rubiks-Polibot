module controle_servo_360 (
    input wire clock,
    input wire reset,
    input wire posicao,
    output wire controle,
    output wire db_reset,
    output wire db_posicao,
    output wire db_controle
);

      circuito_pwm #(           
        .conf_periodo (1000000),   // 20ms = 20ms / 20ns = 1000000 
        .largura_0    (75000  ),   // parado
        .largura_1    (100000  )    // gira
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
