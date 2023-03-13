module mux
(
    input a,
    input b,
    input sel,
    output out
);

// Mux: if sel, output b; else, output a
// out = (sel AND b) OR (NOT sel AND a)

wire sel_n;
wire sel_and_b;
wire sel_n_and_a;

not_n2t invert_sel
(
    .in(sel),
    .out(sel_n)
);

and_n2t use_b
(
    .a(sel),
    .b(b),
    .out(sel_and_b)
);

and_n2t use_a
(
    .a(a),
    .b(sel_n),
    .out(sel_n_and_a)
);

or_n2t result
(
    .a(sel_and_b),
    .b(sel_n_and_a),
    .out(out)
);

endmodule
