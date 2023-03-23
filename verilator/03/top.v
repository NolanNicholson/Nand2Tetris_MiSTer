// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed under the Creative Commons Public Domain, for
// any use, without warranty, 2017 by Wilson Snyder.
// SPDX-License-Identifier: CC0-1.0

// See also https://verilator.org/guide/latest/examples.html"

module top
(
    input clk,
    input in,

    input load_bit,
    input load_register,
    input load_RAM8,
    input load_RAM64,
    input load_RAM512,
    input load_RAM4K,
    input load_RAM16K,

    input [15:0] in16,
    input [15:0] address,

    output out_bit,
    output [15:0] out16_register,
    output [15:0] out16_RAM8,
    output [15:0] out16_RAM64,
    output [15:0] out16_RAM512,
    output [15:0] out16_RAM4K,
    output [15:0] out16_RAM16K
);

Bit test_bit
(
    .clk(clk),
    .in(in),
    .load(load_bit),
    .out(out_bit)
);

Register test_register
(
    .clk(clk),
    .in(in16),
    .load(load_register),
    .out(out16_register)
);

RAM8 test_RAM8
(
    .clk(clk),
    .in(in16),
    .address(address[2:0]),
    .load(load_RAM8),
    .out(out16_RAM8)
);

RAM64 test_RAM64
(
    .clk(clk),
    .in(in16),
    .address(address[5:0]),
    .load(load_RAM64),
    .out(out16_RAM64)
);

RAM512 test_RAM512
(
    .clk(clk),
    .in(in16),
    .address(address[8:0]),
    .load(load_RAM512),
    .out(out16_RAM512)
);

RAM4K test_RAM4K
(
    .clk(clk),
    .in(in16),
    .address(address[11:0]),
    .load(load_RAM4K),
    .out(out16_RAM4K)
);

RAM16K test_RAM16K
(
    .clk(clk),
    .in(in16),
    .address(address[13:0]),
    .load(load_RAM16K),
    .out(out16_RAM16K)
);


// Set up tracing
initial begin
    if ($test$plusargs("trace") != 0) begin
        $display("[%0t] Tracing to logs/vlt_dump.vcd...\n", $time);
        $dumpfile("logs/vlt_dump.vcd");
        $dumpvars();
    end
    $display("[%0t] Model running...\n", $time);
end

endmodule
