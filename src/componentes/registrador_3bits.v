module registrador_3bits (
    input        clock,
    input        clear,
    input        enable,
    input  [2:0] D,
    output [1:0] Q
);

    reg [1:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear) begin
            IQ <= 0;
        end 
        else if (enable) begin
            IQ <= D[1:0];
        end
    end

    assign Q = IQ;

endmodule
