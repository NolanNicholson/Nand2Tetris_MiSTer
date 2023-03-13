module dmux
(
    input in,
    input sel,
    output a,
    output b
);

// dmux: if sel == 0, {a, b} = {in, 0};
//       if sel == 1, {a, b} = {0, in}
// Phrased another way:
// a = sel ? 0 : in
// b = sel ? in : 0

// a = sel ? 0 : in
//   = NOT(sel) AND in
wire sel_n;
not_n2t invert_sel
(
    .in(sel),
    .out(sel_n)
);

and_n2t determine_a
(
    .a(sel_n),
    .b(in),
    .out(a)
);


// b = sel ? in : 0 = sel AND in
and_n2t determine_b
(
    .a(sel),
    .b(in),
    .out(b)
);

endmodule
