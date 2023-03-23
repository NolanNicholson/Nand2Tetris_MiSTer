module Bit
(
    input clk,
    input in,
    input load,
    output out
);

reg dff_out;
wire dff_in = load ? in : dff_out;

// This is the fundamental behavior of a DFF: on each positive clock edge,
// latch the output to the input.
always @(posedge clk) begin
    dff_out <= dff_in;
end

assign out = dff_out;

endmodule
