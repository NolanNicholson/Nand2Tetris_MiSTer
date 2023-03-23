module HalfAdder
(
    input a,
    input b,

    output sum,
    /* verilator lint_off UNOPTFLAT */
    // Reason: this will otherwise complain when trying to pass
    // through a bus of carry signals - e.g., carry[0] in, carry[1] out
    output carry
    /* verilator lint_on UNOPTFLAT */
);

// The strict spirit of Nand to Tetris would be to use the gates
// that we created in the previous chapters. However, it is a much
// more efficient use of both HDL code and FPGA space to just use
// the relevant HDL operators directly. We've learned how XOR can
// be made from NAND, so it's okay. :)
assign sum = a ^ b;
assign carry = a & b;

endmodule
