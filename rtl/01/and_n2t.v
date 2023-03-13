// gate names are reserved identifiers in Verilog; hence the "_n2t" suffix
module and_n2t
(
    input a,
    input b,
    output out
);

wire notout;

// AND is NOT NAND
nand_n2t nand0
(
    .a(a),
    .b(b),
    .out(notout)
);

not_n2t not0
(
    .in(notout),
    .out(out)
);

endmodule
