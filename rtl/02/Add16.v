module Add16
(
    input [15:0] a,
    input [15:0] b,

    output [15:0] out
);


wire carry_0, carry_1, carry_2, carry_3,
    carry_4, carry_5, carry_6, carry_7,
    carry_8, carry_9, carry_10, carry_11,
    carry_12, carry_13, carry_14;

FullAdder fa0
(
    .a(a[0]),
    .b(b[0]),
    .c(0),
    .sum(out[0]),
    .carry(carry_0)
);

FullAdder fa1
(
    .a(a[1]),
    .b(b[1]),
    .c(carry_0),
    .sum(out[1]),
    .carry(carry_1)
);

FullAdder fa2
(
    .a(a[2]),
    .b(b[2]),
    .c(carry_1),
    .sum(out[2]),
    .carry(carry_2)
);

FullAdder fa3
(
    .a(a[3]),
    .b(b[3]),
    .c(carry_2),
    .sum(out[3]),
    .carry(carry_3)
);

FullAdder fa4
(
    .a(a[4]),
    .b(b[4]),
    .c(carry_3),
    .sum(out[4]),
    .carry(carry_4)
);

FullAdder fa5
(
    .a(a[5]),
    .b(b[5]),
    .c(carry_4),
    .sum(out[5]),
    .carry(carry_5)
);

FullAdder fa6
(
    .a(a[6]),
    .b(b[6]),
    .c(carry_5),
    .sum(out[6]),
    .carry(carry_6)
);

FullAdder fa7
(
    .a(a[7]),
    .b(b[7]),
    .c(carry_6),
    .sum(out[7]),
    .carry(carry_7)
);

FullAdder fa8
(
    .a(a[8]),
    .b(b[8]),
    .c(carry_7),
    .sum(out[8]),
    .carry(carry_8)
);

FullAdder fa9
(
    .a(a[9]),
    .b(b[9]),
    .c(carry_8),
    .sum(out[9]),
    .carry(carry_9)
);

FullAdder fa10
(
    .a(a[10]),
    .b(b[10]),
    .c(carry_9),
    .sum(out[10]),
    .carry(carry_10)
);

FullAdder fa11
(
    .a(a[11]),
    .b(b[11]),
    .c(carry_10),
    .sum(out[11]),
    .carry(carry_11)
);

FullAdder fa12
(
    .a(a[12]),
    .b(b[12]),
    .c(carry_11),
    .sum(out[12]),
    .carry(carry_12)
);

FullAdder fa13
(
    .a(a[13]),
    .b(b[13]),
    .c(carry_12),
    .sum(out[13]),
    .carry(carry_13)
);

FullAdder fa14
(
    .a(a[14]),
    .b(b[14]),
    .c(carry_13),
    .sum(out[14]),
    .carry(carry_14)
);

FullAdder fa15
(
    .a(a[15]),
    .b(b[15]),
    .c(carry_14),
    .sum(out[15]),
    .carry() // ignore carry
);


endmodule
