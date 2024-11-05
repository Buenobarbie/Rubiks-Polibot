module servo_360(
    input        clock,
    input        reset,
    input        iniciar,
    output       pronto,
    output reg   pwm,
    output reg [2:0] db_estado
);

  wire s_gira;
  wire s_conta_timer;
  wire s_zera_timer;
  wire s_fim_timer;

  servo_360_uc servo_360_uc (
        .clock   (clock ),
        .reset   (reset ),
        .iniciar (iniciar),
        .fim_timer   (s_fim_timer),
        .gira        (s_gira  ),
        .conta_timer (s_conta_timer),
        .zera_timer  (s_zera_timer),
        .pronto      (pronto),
        .db_estado   (db_estado)
    );

    servo_360_fd servo_360_fd (
        .clock      (clock      ),
        .reset      (reset      ),
        .zera_timer (s_zera_timer ),
        .conta_timer(s_conta_timer),
        .gira       (s_gira       ),
        .fim_timer  (s_fim_timer  ),
        .pwm        (pwm          )
    );

endmodule