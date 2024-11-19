 module transmissao_serial_fd (
    input wire       clock         ,
    input wire       reset         ,
    input wire       partida_serial, 
    input wire       flipa         ,
    input wire       conta_linha   , 
    input wire       conta_coluna  ,
    input wire       zera_linha    ,
    input wire       zera_coluna   ,
    input wire [2:0] dados_pixel,
    output wire      saida_serial  ,
    output wire [1:0] addr_linha, 
    output wire [1:0] addr_coluna,
    output wire      fim_coluna    ,
    output wire      fim_linha     ,
    output wire      pronto        
);


    wire [7:0]  dados_serial;
    assign dados_serial = {5'b0, dados_pixel};



   // Instancia UART
   uart uart(
       .clock           (clock), 
       .reset           (reset),
       .partida         (partida_serial), 
       .dados_ascii     (dados_serial  ),
       .saida_serial    (saida_serial  ),
       .pronto          (pronto),
       .db_tick         (  ), 
       .db_partida      (  ),
       .db_saida_serial (  ),
       .db_estado       (  )
   );

//    // Instancia RAM 3x3
//    ram #(
//        .LINES    (3 ),
//        .COLUMNS  (3 ),
//        .S_DATA   (16),
//        .S_LINE   (2 ),
//        .S_COLUMN (2 )
//    ) ram_3x3 (
//        .clk   (clock),
//        .clear (reset),
//        .we    (  ),
//        .data  (  ),
//        .addr_line   (addr_linha ),
//        .addr_column (addr_coluna),
//        .q           (dados_pixel)
//    );

    
    // Instancia contador de linhas da RAM
    contador_m #(
        .M(4),
        .N(2)
    ) contador_linhas (
        .clock   (clock),
        .zera_as (zera_linha ),
        .zera_s  (zera_linha ),
        .conta   (conta_linha),
        .Q       (addr_linha ),   
        .fim     (fim_linha  ),
        .meio    (  )  
    );

    // Instancia contador de colunas da RAM
    contador_m #(
        .M(3),
        .N(2)
    ) contador_colunas (
        .clock   (clock),
        .zera_as (zera_coluna ),
        .zera_s  (zera_coluna ),
        .conta   (conta_coluna),
        .Q       (addr_coluna ),  
        .fim     (fim_coluna  ),
        .meio    (  )  
    );

endmodule