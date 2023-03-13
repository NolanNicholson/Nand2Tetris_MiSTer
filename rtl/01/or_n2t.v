// gate names are reserved identifiers in Verilog; hence the "_n2t" suffix
module or_n2t
(
    input a,
    input b,
    output out
);

// de Morgan law: NOT (A OR B) = (NOT A) AND (NOT B).
// so, A OR B = NOT ((NOT A) AND (NOT B)) = (NOT A) NAND (NOT B)
wire nota;
wire notb;

not_n2t not0
(
    .in(a),
    .out(nota)
);

not_n2t not1
(
    .in(b),
    .out(notb)
);

nand_n2t nand0
(
    .a(nota),
    .b(notb),
    .out(out)
);


endmodule
