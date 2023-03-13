module dmux8way
(
    input in,
    input [2:0] sel,
    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g,
    output h
);

wire abcd, efgh;

dmux dmux_abcd_efgh
(
    .in(in),
    .sel(sel[2]),
    .a(abcd),
    .b(efgh)
);

dmux4way dmux4way_a_b_c_d
(
    .in(abcd),
    .sel(sel[1:0]),
    .a(a),
    .b(b),
    .c(c),
    .d(d)
);

dmux4way dmux4way_e_f_g_h
(
    .in(efgh),
    .sel(sel[1:0]),
    .a(e),
    .b(f),
    .c(g),
    .d(h)
);

endmodule
