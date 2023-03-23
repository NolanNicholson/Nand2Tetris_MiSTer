module PC
(
    input clk,
    input [15:0] in,
    input load,
    input inc,
    input reset,

    output [15:0] out
);

wire load_reg = load | inc | reset;

// Could be done using Inc16. We'll assume Verilog increments efficiently.
wire [15:0] out_inc = out + 16'h0001;

// Could be done using Mux16. Ternary used here instead for brevity.
wire [15:0] out_maybe_inc = inc ? out_inc : out;
wire [15:0] out_maybe_load = load ? in : out_maybe_inc;
wire [15:0] out_maybe_reset = reset ? 16'h0000 : out_maybe_load;

wire [15:0] in_reg = out_maybe_reset;

Register reg_pc
(
    .clk(clk),
    .in(in_reg),
    .load(load_reg),
    .out(out)
);

endmodule
