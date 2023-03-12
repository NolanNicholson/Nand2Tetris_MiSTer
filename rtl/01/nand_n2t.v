// `nand` is a reserved identifier in Verilog; hence the suffix
module nand_n2t
(
    input a,
    input b,
    output out
);


assign out = ~(a & b);


endmodule
