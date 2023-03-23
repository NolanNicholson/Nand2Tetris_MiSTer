module Register
(
    input clk,
    input [15:0] in,
    input load,

    output [15:0] out
);

Bit bit0
(
    .clk(clk),
    .load(load),
    .in(in[0]),
    .out(out[0])
);

Bit bit1
(
    .clk(clk),
    .load(load),
    .in(in[1]),
    .out(out[1])
);

Bit bit2
(
    .clk(clk),
    .load(load),
    .in(in[2]),
    .out(out[2])
);

Bit bit3
(
    .clk(clk),
    .load(load),
    .in(in[3]),
    .out(out[3])
);

Bit bit4
(
    .clk(clk),
    .load(load),
    .in(in[4]),
    .out(out[4])
);

Bit bit5
(
    .clk(clk),
    .load(load),
    .in(in[5]),
    .out(out[5])
);

Bit bit6
(
    .clk(clk),
    .load(load),
    .in(in[6]),
    .out(out[6])
);

Bit bit7
(
    .clk(clk),
    .load(load),
    .in(in[7]),
    .out(out[7])
);

Bit bit8
(
    .clk(clk),
    .load(load),
    .in(in[8]),
    .out(out[8])
);

Bit bit9
(
    .clk(clk),
    .load(load),
    .in(in[9]),
    .out(out[9])
);

Bit bit10
(
    .clk(clk),
    .load(load),
    .in(in[10]),
    .out(out[10])
);

Bit bit11
(
    .clk(clk),
    .load(load),
    .in(in[11]),
    .out(out[11])
);

Bit bit12
(
    .clk(clk),
    .load(load),
    .in(in[12]),
    .out(out[12])
);

Bit bit13
(
    .clk(clk),
    .load(load),
    .in(in[13]),
    .out(out[13])
);

Bit bit14
(
    .clk(clk),
    .load(load),
    .in(in[14]),
    .out(out[14])
);

Bit bit15
(
    .clk(clk),
    .load(load),
    .in(in[15]),
    .out(out[15])
);

endmodule
