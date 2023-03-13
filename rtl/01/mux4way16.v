module mux4way16
(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    input [15:0] d,
    input [1:0] sel,
    output [15:0] out
);

wire [15:0] muxed_ab;
wire [15:0] muxed_cd;

mux16 mux_ab
(
    .a(a),
    .b(b),
    .sel(sel[0]),
    .out(muxed_ab)
);

mux16 mux_cd
(
    .a(c),
    .b(d),
    .sel(sel[0]),
    .out(muxed_cd)
);

mux16 mux_abcd
(
    .a(muxed_ab),
    .b(muxed_cd),
    .sel(sel[1]),
    .out(out)
);

endmodule
