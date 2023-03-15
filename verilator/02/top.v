// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2017 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

// See also https://verilator.org/guide/latest/examples.html"

module top
(
    input in_a,
    input in_b,
    input in_c,

    input [15:0] in16_a,
    input [15:0] in16_b,

    input [15:0] in16_x,
    input [15:0] in16_y,
    input in_zx,
    input in_nx,
    input in_zy,
    input in_ny,
    input in_f,
    input in_no,

    output out_ha_sum,
    output out_ha_carry,
    output out_fa_sum,
    output out_fa_carry,
    output [15:0] out16_sum,
    output [15:0] out16_inc,
    output [15:0] out16_alu,
    output out_zr,
    output out_ng
);


// Boolean arithmetic

HalfAdder ha
(
    .a(in_a),
    .b(in_b),
    .sum(out_ha_sum),
    .carry(out_ha_carry)
);

FullAdder fa
(
    .a(in_a),
    .b(in_b),
    .c(in_c),
    .sum(out_fa_sum),
    .carry(out_fa_carry)
);

Add16 a16
(
    .a(in16_a),
    .b(in16_b),
    .out(out16_sum)
);

Inc16 i16
(
    .in(in16_a),
    .out(out16_inc)
);

HackALU alu
(
    .x(in16_x),
    .y(in16_y),

    .zx(in_zx),
    .nx(in_nx),
    .zy(in_zy),
    .ny(in_ny),
    .f ( in_f),
    .no(in_no),

    .out(out16_alu),
    .zr(out_zr),
    .ng(out_ng)
);

endmodule
