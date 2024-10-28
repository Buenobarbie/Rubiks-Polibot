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
    reg [7:0] atual;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
            anterior <= 0;
            atual <= 0;
        else if (enable)
            anterior <= atual;
            atual <= D;
            IQ <= {anterior, atual};
    end

    assign Q = IQ;

endmodule