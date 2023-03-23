module RAM8
(
    input clk,
    input [15:0] in,
    input [2:0] address,
    input load,
    output [15:0] out
);

wire load_reg0;
wire load_reg1;
wire load_reg2;
wire load_reg3;
wire load_reg4;
wire load_reg5;
wire load_reg6;
wire load_reg7;

dmux8way dmux_load
(
    .in(load),
    .sel(address),
    .a(load_reg0),
    .b(load_reg1),
    .c(load_reg2),
    .d(load_reg3),
    .e(load_reg4),
    .f(load_reg5),
    .g(load_reg6),
    .h(load_reg7)
);

wire [15:0] out_reg0;
wire [15:0] out_reg1;
wire [15:0] out_reg2;
wire [15:0] out_reg3;
wire [15:0] out_reg4;
wire [15:0] out_reg5;
wire [15:0] out_reg6;
wire [15:0] out_reg7;

Register reg0
(
    .clk(clk),
    .in(in),
    .load(load_reg0),
    .out(out_reg0)
);

Register reg1
(
    .clk(clk),
    .in(in),
    .load(load_reg1),
    .out(out_reg1)
);

Register reg2
(
    .clk(clk),
    .in(in),
    .load(load_reg2),
    .out(out_reg2)
);

Register reg3
(
    .clk(clk),
    .in(in),
    .load(load_reg3),
    .out(out_reg3)
);

Register reg4
(
    .clk(clk),
    .in(in),
    .load(load_reg4),
    .out(out_reg4)
);

Register reg5
(
    .clk(clk),
    .in(in),
    .load(load_reg5),
    .out(out_reg5)
);

Register reg6
(
    .clk(clk),
    .in(in),
    .load(load_reg6),
    .out(out_reg6)
);

Register reg7
(
    .clk(clk),
    .in(in),
    .load(load_reg7),
    .out(out_reg7)
);

mux8way16 mux_output
(
    .a(out_reg0),
    .b(out_reg1),
    .c(out_reg2),
    .d(out_reg3),
    .e(out_reg4),
    .f(out_reg5),
    .g(out_reg6),
    .h(out_reg7),
    .sel(address),
    .out(out)
);

endmodule
