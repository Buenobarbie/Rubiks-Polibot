module pixel_matcher #(parameter N = 8, VALUE1=23, VALUE2=70, VALUE3=117)(
    input [N-1:0] value,
    output match
);

    parameter value1 = VALUE1;
    parameter value2 = VALUE2;
    parameter value3 = VALUE3;

    assign match = (value == value1) || (value == value2) || (value == value3);

endmodule