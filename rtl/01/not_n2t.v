// gate names are reserved identifiers in Verilog; hence the "_n2t" suffix
module not_n2t
(
    input in,
    output out
);

// Feed both inputs of a NAND the same signal, and it will function as a NOT.
nand_n2t nand01
(
    .a(in),
    .b(in),
    .out(out)
);

endmodule
