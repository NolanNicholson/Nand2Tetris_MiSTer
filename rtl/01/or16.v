module or16
(
    input [15:0] a,
    input [15:0] b,
    output [15:0] out
);


or_n2t or0
(
    .a(a[0]),
    .b(b[0]),
    .out(out[0])
);

or_n2t or1
(
    .a(a[1]),
    .b(b[1]),
    .out(out[1])
);

or_n2t or2
(
    .a(a[2]),
    .b(b[2]),
    .out(out[2])
);

or_n2t or3
(
    .a(a[3]),
    .b(b[3]),
    .out(out[3])
);

or_n2t or4
(
    .a(a[4]),
    .b(b[4]),
    .out(out[4])
);

or_n2t or5
(
    .a(a[5]),
    .b(b[5]),
    .out(out[5])
);

or_n2t or6
(
    .a(a[6]),
    .b(b[6]),
    .out(out[6])
);

or_n2t or7
(
    .a(a[7]),
    .b(b[7]),
    .out(out[7])
);

or_n2t or8
(
    .a(a[8]),
    .b(b[8]),
    .out(out[8])
);

or_n2t or9
(
    .a(a[9]),
    .b(b[9]),
    .out(out[9])
);

or_n2t or10
(
    .a(a[10]),
    .b(b[10]),
    .out(out[10])
);

or_n2t or11
(
    .a(a[11]),
    .b(b[11]),
    .out(out[11])
);

or_n2t or12
(
    .a(a[12]),
    .b(b[12]),
    .out(out[12])
);

or_n2t or13
(
    .a(a[13]),
    .b(b[13]),
    .out(out[13])
);

or_n2t or14
(
    .a(a[14]),
    .b(b[14]),
    .out(out[14])
);

or_n2t or15
(
    .a(a[15]),
    .b(b[15]),
    .out(out[15])
);


endmodule
