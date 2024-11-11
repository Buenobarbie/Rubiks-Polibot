module mux_serial (
    input [15:0] hexa_bits,      
    input shift,      
    output [7:0] oct_bits
);

    assign oct_bits = (shift) ? hexa_bits[15:8] : hexa_bits[7:0];
    
endmodule
