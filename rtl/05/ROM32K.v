module ROM32K
(
    input [14:0] address,
    output [15:0] out,

    input clk,
    input [15:0] ioctl_addr,
    input [7:0] ioctl_din,
    input ioctl_wr
);

reg [15:0] ROM [32768];
assign out = ROM[address];

always @(posedge clk) begin
    if (ioctl_wr) begin
        if (ioctl_addr[0]) begin
            ROM[ioctl_addr[15:1]] [15:8] <= ioctl_din;
        end else begin
            ROM[ioctl_addr[15:1]] [7:0] <= ioctl_din;
        end
    end
end

endmodule
