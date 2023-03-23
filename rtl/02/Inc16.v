module Inc16
(
    input [15:0] in,
    output [15:0] out
);

/* verilator lint_off UNOPTFLAT */
// Reason: this will otherwise complain when trying to pass
// through a bus of carry signals - e.g., carry[0] in, carry[1] out
wire [14:0] carry;
/* verilator lint_on UNOPTFLAT */

HalfAdder ha0
(
    .a(1),
    .b(in[0]),
    .sum(out[0]),
    .carry(carry[0])
);

HalfAdder ha1
(
    .a(carry[0]),
    .b(in[1]),
    .sum(out[1]),
    .carry(carry[1])
);

HalfAdder ha2
(
    .a(carry[1]),
    .b(in[2]),
    .sum(out[2]),
    .carry(carry[2])
);

HalfAdder ha3
(
    .a(carry[2]),
    .b(in[3]),
    .sum(out[3]),
    .carry(carry[3])
);

HalfAdder ha4
(
    .a(carry[3]),
    .b(in[4]),
    .sum(out[4]),
    .carry(carry[4])
);

HalfAdder ha5
(
    .a(carry[4]),
    .b(in[5]),
    .sum(out[5]),
    .carry(carry[5])
);

HalfAdder ha6
(
    .a(carry[5]),
    .b(in[6]),
    .sum(out[6]),
    .carry(carry[6])
);

HalfAdder ha7
(
    .a(carry[6]),
    .b(in[7]),
    .sum(out[7]),
    .carry(carry[7])
);

HalfAdder ha8
(
    .a(carry[7]),
    .b(in[8]),
    .sum(out[8]),
    .carry(carry[8])
);

HalfAdder ha9
(
    .a(carry[8]),
    .b(in[9]),
    .sum(out[9]),
    .carry(carry[9])
);

HalfAdder ha10
(
    .a(carry[9]),
    .b(in[10]),
    .sum(out[10]),
    .carry(carry[10])
);

HalfAdder ha11
(
    .a(carry[10]),
    .b(in[11]),
    .sum(out[11]),
    .carry(carry[11])
);

HalfAdder ha12
(
    .a(carry[11]),
    .b(in[12]),
    .sum(out[12]),
    .carry(carry[12])
);

HalfAdder ha13
(
    .a(carry[12]),
    .b(in[13]),
    .sum(out[13]),
    .carry(carry[13])
);

HalfAdder ha14
(
    .a(carry[13]),
    .b(in[14]),
    .sum(out[14]),
    .carry(carry[14])
);

HalfAdder ha15
(
    .a(carry[14]),
    .b(in[15]),
    .sum(out[15]),
    .carry() // carry ignored
);

// TODO

endmodule
