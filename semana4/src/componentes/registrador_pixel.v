// REGISTRADOR SÍNCRONO DE 16 BITS -------------------------------------------------------
module registrador_pixel (
    input        clock,
    input        clear,
    input        enable,
    input  [7:0] D,
    output [15:0] Q
);

    reg [15:0] IQ;
    reg [7:0] anterior;

    always @(posedge clock or posedge clear) begin
        if (clear) begin
            IQ <= 0;
            anterior <= 0;
        end 
        else if (enable) begin
            IQ <= {anterior, D};
            anterior <= D;
        end
    end

    assign Q = IQ;

endmodule
