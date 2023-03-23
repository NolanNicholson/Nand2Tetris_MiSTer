module RAM4K
(
    input clk,
    input [15:0] in,
    input [11:0] address,
    input load,
    output [15:0] out
);

reg [15:0] RAM [4096];

always @(posedge clk) begin
    if (load) begin
        RAM[address] = in;
    end
end

assign out = RAM[address];

endmodule
