// Código que percorre uma memoria 3x3 de pixels e identifica a cor predominante
// de cada pixel
module identifica_cores 
(
    input wire       clock,
    input wire       reset,
    input wire       iniciar,
    input wire [15:0] pixel,
    output wire       we_cor,
    output wire       pronto,
    output wire [1:0] linha_pixel_addr,
    output wire [1:0] coluna_pixel_addr,
    output wire [2:0] cor_final,
    output wire [3:0] db_estado

);


    wire s_fim_cor;
    wire s_fim_coluna_pixel;
    wire s_fim_linha_pixel;
    wire s_zera_linha_pixel;
    wire s_zera_coluna_pixel;
    wire s_zera_cor;
    wire s_conta_cor;
    wire s_conta_linha_pixel;
    wire s_conta_coluna_pixel;
    wire s_we_dist;


    identifica_cores_uc identifica_cores_uc (
        .clock      (clock),
        .reset      (reset),
        .iniciar    (iniciar),
        .fim_cor    (s_fim_cor),
        .fim_coluna (s_fim_coluna_pixel),
        .fim_linha  (s_fim_linha_pixel),
        .zera_linha (s_zera_linha_pixel),
        .zera_coluna(s_zera_coluna_pixel),
        .zera_cor   (s_zera_cor),
        .conta_cor  (s_conta_cor),
        .conta_linha(s_conta_linha_pixel),
        .conta_coluna(s_conta_coluna_pixel),
        .we_dist    (s_we_dist),
        .we_cor     (we_cor),
        .pronto     (pronto),
        .db_estado  (db_estado)
    );

    identifica_cores_fd identifica_cores_fd (
        .clock              (clock),
        .reset              (reset),
        .pixel              (pixel),
        .zera_linha_pixel   (s_zera_linha_pixel),
        .zera_coluna_pixel  (s_zera_coluna_pixel),
        .zera_cor           (s_zera_cor),
        .we_dist            (s_we_dist),
        .conta_coluna_pixel (s_conta_coluna_pixel),
        .conta_linha_pixel  (s_conta_linha_pixel),
        .conta_cor          (s_conta_cor),
        .linha_pixel_addr   (linha_pixel_addr),
        .coluna_pixel_addr  (coluna_pixel_addr),
        .fim_linha_pixel    (s_fim_linha_pixel),
        .fim_coluna_pixel   (s_fim_coluna_pixel),
        .cor_final          (cor_final)
    );


endmodule
