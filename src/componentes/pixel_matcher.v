module pixel_matcher #(parameter N = 8, VALUE1=23, VALUE2=70, VALUE3=117)(
    input [N-1:0] value,
    output match
);


    assign match = (value == VALUE1) || (value == VALUE2) || (value == VALUE3);

endmodule