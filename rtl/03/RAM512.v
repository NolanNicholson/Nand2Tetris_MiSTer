module RAM512
(
    input clk,
    input [15:0] in,
    input [8:0] address,
    input load,
    output [15:0] out
);

/*
 * Although it is possible to do exactly the same thing for RAM512 as we did
 * for RAM8 and RAM64 - combine 8 smaller RAM units (RAM64's in this case)
 * together using an 8-way dmux on the load bit and an 8-way mux on the data
 * output - doing so for the larger RAMs would start to get extremely wasteful
 * of both Verilog simulation power and real FPGA space.
 *
 * Although this combination of smaller modules is how many RAMs work in
 * practice, both Verilator and FPGAs will behave much more efficiently if
 * they are given a simple RAM definition and allowed to manage it themselves.
 * If this is done, Verilator will assign a segment of computer RAM, and FPGAs
 * will use on-board block RAM instead of defining the RAM using logic space.
 */

reg [15:0] RAM [512];

always @(posedge clk) begin
    if (load) begin
        RAM[address] = in;
    end
end

assign out = RAM[address];

endmodule
