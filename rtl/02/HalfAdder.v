module HalfAdder
(
    input a,
    input b,
    output sum,
    output carry
);

// The strict spirit of Nand to Tetris would be to use the gates
// that we created in the previous chapters. However, it is a much
// more efficient use of both HDL code and FPGA space to just use
// the relevant HDL operators directly. We've learned how XOR can
// be made from NAND, so it's okay. :)
assign sum = a ^ b;
assign carry = a & b;

endmodule
