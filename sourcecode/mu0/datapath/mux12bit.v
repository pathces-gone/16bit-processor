module mux12bit(
    input s,
    input [11:0] a,
    input [11:0] b,
    output [11:0] out
);

    assign out = s ? a:b;

endmodule