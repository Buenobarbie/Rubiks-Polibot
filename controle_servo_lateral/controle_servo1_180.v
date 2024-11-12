module controle_servo1_180 (
    input wire clock,
    input wire reset,
    input wire posicao,
    output wire controle,
    output wire db_reset,
    output wire db_posicao,
    output wire db_controle
);

//      // servo  LATERAL CHECK 
//		circuito_pwm #(           
//        .conf_periodo (1000000),   // 20ms = 20ms / 20ns = 1000000 
//        .largura_0    (27144  ),   // 0º - 27144
//        .largura_1    (70000  )    // 100º - 78735
//      ) controle_servo (
//        .clock   (clock   ),
//        .reset   (reset   ),
//        .largura (posicao ),
//        .pwm     (controle)
//    );
	 
////	 // servo BASE
		circuito_pwm #(           
        .conf_periodo (1000000),   
        .largura_0    (28204  ),   
        .largura_1    (70000  )   
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
