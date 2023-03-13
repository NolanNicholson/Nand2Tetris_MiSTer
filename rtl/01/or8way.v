module or8way
(
    input [7:0] in,
    output out
);

wire or_out0;
wire or_out1;
wire or_out2;
wire or_out3;
wire or_out4;
wire or_out5;

or_n2t or0
(
    .a(in[0]),
    .b(in[1]),
    .out(or_out0)
);

or_n2t or1
(
    .a(or_out0),
    .b(in[2]),
    .out(or_out1)
);

or_n2t or2
(
    .a(or_out1),
    .b(in[3]),
    .out(or_out2)
);

or_n2t or3
(
    .a(or_out2),
    .b(in[4]),
    .out(or_out3)
);

or_n2t or4
(
    .a(or_out3),
    .b(in[5]),
    .out(or_out4)
);

or_n2t or5
(
    .a(or_out4),
    .b(in[6]),
    .out(or_out5)
);

or_n2t or6
(
    .a(or_out5),
    .b(in[7]),
    .out(out)
);

endmodule
