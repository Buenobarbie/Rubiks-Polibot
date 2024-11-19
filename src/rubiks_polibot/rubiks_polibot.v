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

    wire s_iniciar;
    // Edge detector BOTÃO INICIAR
    edge_detector edge_iniciar (
        .clock  (clock ),
        .reset  (reset ),
        .sinal  (~iniciar),
        .pulso  (s_iniciar)
    );

    // Fios internos
    wire s_zera_face;
    wire s_zera_movimento;
    wire s_captura_imagem;
    wire s_identificar_cores;
    wire s_enviar_cores;
    wire s_aciona_movimento;
    wire s_conta_movimento;
    wire s_conta_face;
    wire s_pronto;

    wire s_obter_movimentos;
    wire s_sel_ram_pixel;
    wire s_sel_cor;
    wire s_sel_serial1;
    wire s_sel_serial2;
    wire s_sel_movimento;
    wire s_imagem_recebida;
    wire s_cores_identificadas;
    wire s_cores_transmitidas;
    wire s_fim_face;
    wire s_fim_movimento;
    wire s_movimento_par;
    wire s_meio_face;
    wire s_movimentos_recebidos;
    wire s_fim_rom;
    wire [2:0] s_db_movimento;
    wire [3:0] s_db_estado;


    // Unidade de controle
    rubiks_polibot_uc uc (
        .clock          (clock),
        .reset          (reset),
        .iniciar        (s_iniciar),
        .imagem_recebida(s_imagem_recebida),
        .cores_identificadas(s_cores_identificadas),
        .cores_transmitidas(s_cores_transmitidas),
        .fim_face       (s_fim_face),
        .fim_movimento  (s_fim_movimento),
        .movimento_par  (s_movimento_par),
        .meio_face      (s_meio_face),
        .movimentos_recebidos(s_movimentos_recebidos),
        .fim_rom        (s_fim_rom),
        .zera_face      (s_zera_face),
        .zera_movimento (s_zera_movimento),
        .captura_imagem (s_captura_imagem),
        .identificar_cores(s_identificar_cores),
        .enviar_cores   (s_enviar_cores),
        .aciona_movimento(s_aciona_movimento),
        .conta_movimento(s_conta_movimento),
        .conta_face     (s_conta_face),
        .pronto         (s_pronto),
        .obter_movimentos(s_obter_movimentos),
        .sel_ram_pixel  (s_sel_ram_pixel),
        .sel_cor        (s_sel_cor),
        .sel_serial1    (s_sel_serial1),
        .sel_serial2    (s_sel_serial2),
        .sel_movimento  (s_sel_movimento),
        .db_estado      (s_db_estado)
    );

    // Fluxo de dados
    rubiks_polibot_fd fd (
        .clock          (clock),
        .reset          (reset),
        .iniciar       (s_iniciar),
        .zera_face      (s_zera_face),
        .zera_movimento (s_zera_movimento),
        .captura_imagem (s_captura_imagem),
        .identificar_cores(s_identificar_cores),
        .enviar_cores   (s_enviar_cores),
        .aciona_movimento(s_aciona_movimento),
        .conta_movimento(s_conta_movimento),
        .conta_face     (s_conta_face),
        .pronto         (s_pronto),
        .obter_movimentos(s_obter_movimentos),
        .rx_serial      (rx_serial),
        .sel_serial1    (s_sel_serial1),
        .sel_serial2    (s_sel_serial2),
        .sel_ram_pixel  (s_sel_ram_pixel),
        .sel_cor        (s_sel_cor),
        .sel_movimento  (s_sel_movimento),
        .imagem_recebida(s_imagem_recebida),
        .cores_identificadas(s_cores_identificadas),
        .cores_transmitidas(s_cores_transmitidas),
        .fim_face       (s_fim_face),
        .fim_movimento  (s_fim_movimento),
        .movimento_par  (s_movimento_par),
        .meio_face      (s_meio_face),
        .movimentos_recebidos(s_movimentos_recebidos),
        .fim_rom        (s_fim_rom),
        .pwm_base       (pwm_base),
        .pwm_tampa      (pwm_tampa),
        .pwm_peteleco   (pwm_peteleco),
        .saida_serial   (saida_serial),
        .db_movimento   (s_db_movimento)

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
