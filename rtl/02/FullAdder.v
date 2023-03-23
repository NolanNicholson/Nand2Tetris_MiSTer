module FullAdder
(
    input a,
    input b,
    input c,
    output sum,
    output carry
);

wire sum_ha1, carry_ha1, carry_ha2;

HalfAdder ha1
(
    .a(a),
    .b(b),
    .sum(sum_ha1),
    .carry(carry_ha1)
);

HalfAdder ha2
(
    .a(sum_ha1),
    .b(c),
    .sum(sum),
    .carry(carry_ha2)
);

assign carry = carry_ha1 ^ carry_ha2;

endmodule
