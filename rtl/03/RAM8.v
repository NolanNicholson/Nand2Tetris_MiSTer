module RAM8
(
    input clk,
    input [15:0] in,
    input [2:0] address,
    input load,
    output [15:0] out
);

reg [15:0] RAM [8];

always @(posedge clk) begin
    if (load) begin
        RAM[address] = in;
    end
end

assign out = RAM[address];

endmodule
