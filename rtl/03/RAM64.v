module RAM64
(
    input clk,
    input [15:0] in,
    input [5:0] address,
    input load,
    output [15:0] out
);

wire [2:0] addr_high = address[5:3];
wire [2:0] addr_low = address[2:0];

wire load_ram0;
wire load_ram1;
wire load_ram2;
wire load_ram3;
wire load_ram4;
wire load_ram5;
wire load_ram6;
wire load_ram7;

dmux8way dmux_load
(
    .in(load),
    .sel(addr_high),
    .a(load_ram0),
    .b(load_ram1),
    .c(load_ram2),
    .d(load_ram3),
    .e(load_ram4),
    .f(load_ram5),
    .g(load_ram6),
    .h(load_ram7)
);

wire [15:0] out_ram0;
wire [15:0] out_ram1;
wire [15:0] out_ram2;
wire [15:0] out_ram3;
wire [15:0] out_ram4;
wire [15:0] out_ram5;
wire [15:0] out_ram6;
wire [15:0] out_ram7;

RAM8 ram0
(
    .clk(clk),
    .in(in),
    .address(addr_low),
    .load(load_ram0),
    .out(out_ram0)
);

RAM8 ram1
(
    .clk(clk),
    .in(in),
    .address(addr_low),
    .load(load_ram1),
    .out(out_ram1)
);

RAM8 ram2
(
    .clk(clk),
    .in(in),
    .address(addr_low),
    .load(load_ram2),
    .out(out_ram2)
);

RAM8 ram3
(
    .clk(clk),
    .in(in),
    .address(addr_low),
    .load(load_ram3),
    .out(out_ram3)
);

RAM8 ram4
(
    .clk(clk),
    .in(in),
    .address(addr_low),
    .load(load_ram4),
    .out(out_ram4)
);

RAM8 ram5
(
    .clk(clk),
    .in(in),
    .address(addr_low),
    .load(load_ram5),
    .out(out_ram5)
);

RAM8 ram6
(
    .clk(clk),
    .in(in),
    .address(addr_low),
    .load(load_ram6),
    .out(out_ram6)
);

RAM8 ram7
(
    .clk(clk),
    .in(in),
    .address(addr_low),
    .load(load_ram7),
    .out(out_ram7)
);

mux8way16 mux_output
(
    .a(out_ram0),
    .b(out_ram1),
    .c(out_ram2),
    .d(out_ram3),
    .e(out_ram4),
    .f(out_ram5),
    .g(out_ram6),
    .h(out_ram7),
    .sel(addr_high),
    .out(out)
);

endmodule
