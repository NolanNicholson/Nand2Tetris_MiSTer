module Screen
(
    input clk,
    input reset,

    input [15:0] in, // What to write
    input [12:0] address, // Where to read/write
    input load, // Write-enable bit

    output [15:0] out, // Screen value at the given address

    // Not part of original Hack specification. These signals allow us display
    // video, pixel by pixel, line by line, like a real computer does.
    output reg video_color,
    output reg video_hsync,
    output reg video_vsync
);

reg [9:0] h;
reg [8:0] v;

reg [15:0] screen_ram [8192];


// Manage screen as RAM
assign out = screen_ram[address];
always @(posedge clk) begin
    if (load) begin
        screen_ram[address] = in;
    end
end

wire [12:0] video_addr = { v[7:0], h[8:4] };
wire [15:0] video_block = screen_ram[video_addr];

// Video output process
always @(posedge clk) begin

    if (reset) begin
        video_color <= 1'b0;
        h <= 10'd0;
        v <= 9'd0;

    end else begin
        video_color <= video_block[h[3:0]];

        // Horizontal counter/sync
        h <= h + 10'd1;

        if (h == 10'd511) begin
            video_hsync <= 1;
        end else if (h == 10'd560) begin
            video_hsync <= 0;
            h <= 10'd0;

            // Vertical counter/sync
            v <= v + 9'd1;

            if (v == 9'd255) begin
                video_vsync <= 1;
            end else if (v == 9'd275) begin
                video_vsync <= 0;
                v <= 9'd0;
            end
        end
    end
end

endmodule
