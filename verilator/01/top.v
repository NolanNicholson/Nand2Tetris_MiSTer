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
    input in_sel,

    input [15:0] in16_a,
    input [15:0] in16_b,
    input [15:0] in16_c,
    input [15:0] in16_d,
    input [15:0] in16_e,
    input [15:0] in16_f,
    input [15:0] in16_g,
    input [15:0] in16_h,

    input [7:0] in8_a,

    input [1:0] in2_sel,
    input [2:0] in3_sel,

    output out_nand,
    output out_not,
    output out_and,
    output out_or,
    output out_xor,
    output out_mux,
    output out_dmux_a,
    output out_dmux_b,

    output [15:0] out16_not,
    output [15:0] out16_and,
    output [15:0] out16_or,
    output [15:0] out16_mux,
    output [15:0] out16_mux4,
    output [15:0] out16_mux8,

    output out_or8way,

    output out_dmux4_a,
    output out_dmux4_b,
    output out_dmux4_c,
    output out_dmux4_d,

    output out_dmux8_a,
    output out_dmux8_b,
    output out_dmux8_c,
    output out_dmux8_d,
    output out_dmux8_e,
    output out_dmux8_f,
    output out_dmux8_g,
    output out_dmux8_h
);


// Basic logic gates

nand_n2t nand01
(
    .a(in_a),
    .b(in_b),
    .out(out_nand)
);

not_n2t not01
(
    .in(in_a),
    .out(out_not)
);

and_n2t and01
(
    .a(in_a),
    .b(in_b),
    .out(out_and)
);

or_n2t or01
(
    .a(in_a),
    .b(in_b),
    .out(out_or)
);

xor_n2t xor01
(
    .a(in_a),
    .b(in_b),
    .out(out_xor)
);

mux mux
(
    .a(in_a),
    .b(in_b),
    .sel(in_sel),
    .out(out_mux)
);

dmux dmux
(
    .in(in_a),
    .sel(in_sel),
    .a(out_dmux_a),
    .b(out_dmux_b)
);


// 16-bit logic gates

not16 not16
(
    .in(in16_a),
    .out(out16_not)
);

and16 and16
(
    .a(in16_a),
    .b(in16_b),
    .out(out16_and)
);

or16 or16
(
    .a(in16_a),
    .b(in16_b),
    .out(out16_or)
);

mux16 mux16
(
    .a(in16_a),
    .b(in16_b),
    .sel(in_sel),
    .out(out16_mux)
);

or8way or8way
(
    .in(in8_a),
    .out(out_or8way)
);

mux4way16 mux4way16
(
    .a(in16_a),
    .b(in16_b),
    .c(in16_c),
    .d(in16_d),
    .sel(in2_sel),
    .out(out16_mux4)
);

mux8way16 mux8way16
(
    .a(in16_a),
    .b(in16_b),
    .c(in16_c),
    .d(in16_d),
    .e(in16_e),
    .f(in16_f),
    .g(in16_g),
    .h(in16_h),
    .sel(in3_sel),
    .out(out16_mux8)
);

dmux4way dmux4way
(
    .in(in_a),
    .sel(in2_sel),
    .a(out_dmux4_a),
    .b(out_dmux4_b),
    .c(out_dmux4_c),
    .d(out_dmux4_d)
);

dmux8way dmux8way
(
    .in(in_a),
    .sel(in3_sel),
    .a(out_dmux8_a),
    .b(out_dmux8_b),
    .c(out_dmux8_c),
    .d(out_dmux8_d),
    .e(out_dmux8_e),
    .f(out_dmux8_f),
    .g(out_dmux8_g),
    .h(out_dmux8_h)
);

endmodule
