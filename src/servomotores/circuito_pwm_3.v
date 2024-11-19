module circuito_pwm_3 #(         
    parameter conf_periodo = 1250,
    parameter largura_0   = 0,
    parameter largura_1   = 50,
    parameter largura_2   = 100
) (
    input        clock,
    input        reset,
    input  [1:0] largura,
    output reg   pwm
);

reg [31:0] contagem; // contador interno (32 bits) para acomodar conf_periodo 
reg [31:0] largura_pwm; 

always @(posedge clock or posedge reset) begin
    if (reset) begin
        contagem <= 0;
        pwm <= 0;
        largura_pwm <= largura_0; // Valor inicial da largura do pulso
    end else begin
        // Saída PWM
        pwm <= (contagem < largura_pwm);

        // Atualização do contador e da largura do pulso
        if (contagem == conf_periodo - 1) begin
            contagem <= 0;
            case (largura)
                2'b00: largura_pwm <= largura_0;
                2'b01: largura_pwm <= largura_1;
                2'b10: largura_pwm <= largura_2;
                default: largura_pwm <= largura_0; 
            endcase
        end else begin
            contagem <= contagem + 1;
        end
    end
end

endmodule