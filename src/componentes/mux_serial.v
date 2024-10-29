module mux_serial (
    input [15:0] 16_bits,      
    input shift,      
    output [7:0] 8_bits
);

    reg [7:0] aux;

    if(shift) begin 
        aux <= 16_bits[15:8];
    end else begin 
        aux <= 16_bits[7:0];
    end

    assign 8_bits = aux; 
    
endmodule
