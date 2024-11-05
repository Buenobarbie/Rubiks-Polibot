
 
module circuito_pwm_360 #(    // valores default
    parameter conf_periodo = 1250,  // Período do sinal PWM [1250 => f=4KHz (25us)]
    parameter largura_0   = 0,     // Largura do pulso p/ 000 [0 => 0]
    parameter largura_1   = 50    // Largura do pulso p/ 001 [50 => 1us]
) (
    input        clock,
    input        reset,
    input        largura,
    output reg   pwm
);

reg [31:0] contagem; // contador interno (32 bits) para acomodar conf_periodo 
reg [31:0] largura_pwm; 

always @(posedge clock or posedge reset) begin
    if (reset) begin
        contagem <= 0;
        pwm <= 0;
        largura_pwm <= largura_00; // Valor inicial da largura do pulso
    end else begin
        // Saída PWM
        pwm <= (contagem < largura_pwm);

        // Atualização do contador e da largura do pulso
        if (contagem == conf_periodo - 1) begin
            contagem <= 0;
            case (largura)
                1'b0: largura_pwm <= largura_0;
                1'b1: largura_pwm <= largura_1;
                default: largura_pwm <= largura_0; 
            endcase
        end else begin
            contagem <= contagem + 1;
        end
    end
end

endmodule