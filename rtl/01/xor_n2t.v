// gate names are reserved identifiers in Verilog; hence the "_n2t" suffix
module xor_n2t
(
    input a,
    input b,
    output out
);

// A XOR B = (A OR B) AND (NOT (A AND B))
//         = (A OR B) AND (A NAND B)
wire a_or_b;
wire a_nand_b;

or_n2t or0
(
    .a(a),
    .b(b),
    .out(a_or_b)
);

nand_n2t nand0
(
    .a(a),
    .b(b),
    .out(a_nand_b)
);

and_n2t and0
(
    .a(a_or_b),
    .b(a_nand_b),
    .out(out)
);

endmodule
