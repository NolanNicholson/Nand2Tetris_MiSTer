module mux8way16
(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [15:0] e,
    input [15:0] f,
    input [15:0] g,
    input [15:0] h,
    input [2:0] sel,
    output [15:0] out
);

wire [15:0] muxed_abcd;
wire [15:0] muxed_efgh;

mux4way16 mux_abcd
(
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .sel(sel[1:0]),
    .out(muxed_abcd)
);

mux4way16 mux_efgh
(
    .a(e),
    .b(f),
    .c(g),
    .d(h),
    .sel(sel[1:0]),
    .out(muxed_efgh)
);

mux16 mux_abcdefgh
(
    .a(muxed_abcd),
    .b(muxed_efgh),
    .sel(sel[2]),
    .out(out)
);

endmodule
