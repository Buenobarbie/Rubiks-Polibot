 module servo_360_fd (
    input wire       clock        ,
    input wire       reset        ,
    input wire       zera_timer   ,
    input wire       conta_timer  , 
    input wire       gira         ,
    output wire      fim_timer    ,
    output wire      pwm          ,
);

    // Instancia Controle Servo
    controle_servo_360 (
        .clock       (clock),
        .reset       (reset),
        .posicao     (gira ),
        .controle    (pwm  ),
        .db_reset    (  ),
        .db_posicao  (  ),
        .db_controle (  )
    );

    // Instancia contador 
    contador_m #(
        .M(50000000),
        .N(26)
    ) contador_colunas (
        .clock   (clock),
        .zera_as (zera_timer  ),
        .zera_s  (zera_timer  ),
        .conta   (conta_timer ),
        .Q       (  ),  
        .fim     (fim_timer   ),
        .meio    (  )  
    );

endmodule
