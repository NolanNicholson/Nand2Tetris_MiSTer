// gate names are reserved identifiers in Verilog; hence the "_n2t" suffix
module nand_n2t
(
    input a,
    input b,
    output out
);


assign out = ~(a & b);


endmodule
