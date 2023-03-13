module dmux4way
(
    input in,
    input [1:0] sel,
    output a,
    output b,
    output c,
    output d
);

wire ab, cd;

dmux dmux_ab_cd
(
    .in(in),
    .sel(sel[1]),
    .a(ab),
    .b(cd)
);

dmux dmux_a_b
(
    .in(ab),
    .sel(sel[0]),
    .a(a),
    .b(b)
);

dmux dmux_c_d
(
    .in(cd),
    .sel(sel[0]),
    .a(c),
    .b(d)
);

endmodule
