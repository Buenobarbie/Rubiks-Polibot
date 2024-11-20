
module transmissao_serial (
    input        clock            ,
    input        reset            ,
    input        iniciar          , 
    output       saida_serial     , 
    output       fim              ,
    output       db_partida_serial,
    output       db_saida_serial  ,
    input [2:0] dados_pixel      ,
    output [1:0] addr_linha       ,
    output [1:0] addr_coluna      ,
    output [6:0] db_estado       
);
 
    wire s_reset;
    wire s_iniciar;
    wire s_partida_serial;
    wire s_flipa;      
    wire s_conta_linha; 
    wire s_conta_coluna; 
    wire s_zera_linha; 
    wire s_zera_coluna; 
    wire s_saida_serial;
    wire s_fim_coluna; 
    wire s_fim_linha;
    wire s_pronto;
    wire s_shift_serial;
    wire s_db_estado;

	// sinais reset e partida (ativos em alto - GPIO)
    assign s_reset   = reset;
    assign s_iniciar = iniciar;
	 
    // fluxo de dados
    transmissao_serial_fd U1_FD (
        .clock          ( clock           ),
        .reset          ( s_reset         ),
        .partida_serial ( s_partida_serial),
        .conta_linha    ( s_conta_linha   ),
        .conta_coluna   ( s_conta_coluna  ),
        .zera_linha     ( s_zera_linha    ),
        .zera_coluna    ( s_zera_coluna   ),
        .dados_pixel    ( {5'b0,dados_pixel}     ),
        .addr_linha     ( addr_linha      ),
        .addr_coluna    ( addr_coluna     ),
        .saida_serial   ( s_saida_serial  ),
        .fim_coluna     ( s_fim_coluna    ),
        .fim_linha      ( s_fim_linha     ),
        .pronto         ( s_pronto        )
    );

    // unidade de controle
    transmissao_serial_uc U2_UC (
        .clock          ( clock           ),
        .reset          ( s_reset         ),
        .iniciar        ( s_iniciar       ),
        .pronto         ( s_pronto        ),
        .fim_linha      ( s_fim_linha     ),
        .fim_coluna     ( s_fim_coluna    ),
        .partida_serial ( s_partida_serial), 
        .conta_linha    ( s_conta_linha   ),
        .conta_coluna   ( s_conta_coluna  ),
        .zera_linha     ( s_zera_linha    ),
        .zera_coluna    ( s_zera_coluna   ),
        .db_estado      ( s_db_estado     )
    );

    hexa7seg hexa_estado (
		.hexa(s_db_estado),
		.display(db_estado)
	 );

    // saidas
    assign saida_serial = s_saida_serial;
    assign fim = s_fim_linha;

    // depuracao
    // precisa ter tick??
    // assign db_tick           = s_tick;
    assign db_partida_serial = s_partida_serial;
    assign db_saida_serial   = s_saida_serial;
endmodule