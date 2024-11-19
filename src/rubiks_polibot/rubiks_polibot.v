/* --------------------------------------------------------------------------
 *  Arquivo   : rubiks_polibot.v
 * --------------------------------------------------------------------------
 *  Descricao : Código principal do funcionamento do Rubik's Polibot,
 *              o robô que resolve o cubo mágico 3x3.
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autoras             
 *      17/11/2024  1.0     Bárbara Bueno       
 *                          Juliana Mitie
 *                          Tássyla Lima
 * --------------------------------------------------------------------------
 */

 
module rubiks_polibot 
(
    input wire       clock,
    input wire       reset,
    input wire       iniciar,
    input wire       rx_serial,
	output wire      saida_serial,
    output wire      pwm_peteleco,
    output wire      pwm_tampa,
    output wire      pwm_base,
	output wire [6:0] db_estado,
    output wire [2:0] db_movimento


);



    // Edge detector BOTÃO INICIAR
    edge_detector edge_iniciar (
        .clock  (clock ),
        .reset  (reset ),
        .sinal  (~iniciar),
        .pulso  (s_iniciar)
    );

    
     hexa7seg hexa4_movimento (
		.hexa(s_db_movimento),
		.display(db_movimento)
	 );

	 
	 hexa7seg hexa5_estado (
		.hexa(s_db_estado),
		.display(db_estado)
	 );
	 

	 
endmodule
