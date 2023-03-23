module HackALU
(
    input [15:0] x,
    input [15:0] y,

    output [15:0] out,

    input zx,
    input nx,
    input zy,
    input ny,
    input f,
    input no,

    output zr,
    output ng
);

// NOTE: The 16-bit chips from Chapter 1 could be used here (and
// that is the book's intent), but it's more concise and more efficient
// to use Verilog's built-in operators for these. So:
// - instead of Mux16, the ternary ?: operator is used.
// - instead of Add16, the addition operator + is used.
// - instead of And16, the bitwise AND operator & is used.
// - instead of Not16, the bitwise NOT operator ~ is used.
// - instead of one or more Or8Way gates, the unary OR operator | is used.

// First, optionally preset the inputs to 0
wire [15:0] x_z = zx ? 16'h0000 : x;
wire [15:0] y_z = zy ? 16'h0000 : y;

// Second, optionally invert the inputs
wire [15:0] x_z_inv = ~x_z;
wire [15:0] y_z_inv = ~y_z;
wire [15:0] x_zn = nx ? x_z_inv : x_z;
wire [15:0] y_zn = ny ? y_z_inv : y_z;

// Perform arithmetic (+ or &, depending on f)
wire [15:0] func_add = x_zn + y_zn;
wire [15:0] func_and = x_zn & y_zn;
wire [15:0] func = f ? func_add : func_and;

// Finally, optionally invert the output
wire [15:0] func_inv = ~func;
assign out = no ? func_inv : func;

// Output flags
// If | is used with just one operator, it OR's all the bits together.
assign zr = ~(|out);
// In two's-complement, the MSB matches the sign.
assign ng = out[15];

endmodule
