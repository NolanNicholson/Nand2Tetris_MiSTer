module RAM16K
(
    input clk,
    input [15:0] in,
    input [13:0] address,
    input load,
    output [15:0] out
);

reg [15:0] RAM [16384];

always @(posedge clk) begin
    if (load) begin
        RAM[address] = in;
    end
end

assign out = RAM[address];

endmodule
