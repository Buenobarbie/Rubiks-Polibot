module servo_matcher(
    input [2:0] move,        
    output wire peteleco,
    output wire tampa,
    output wire base 
);

    assign peteleco = ~move[2] && ~move[1] && move[0];
    assign tampa = ~move[2] && move[1] && ~move[0];
    assign base = move[2]

endmodule
