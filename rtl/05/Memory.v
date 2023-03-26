module Memory
(
    input clk,
    input reset,

    input [15:0] in,
    input [14:0] address,
    input load,
    output reg [15:0] out,

    // Not part of original Hack specification.
    // Passthrough for Screen's video.
    output video_color,
    output video_hsync,
    output video_vsync
);

// Memory map:
// 0XX_XXXX_XXXX_XXXX: RAM
// 10X_XXXX_XXXX_XXXX: Screen
// 110_0000_0000_0000: Keyboard
wire addr_ram = ~address[14];
wire addr_screen = address[14] & ~address[13];
wire addr_keyboard = (address == 15'h6000);

wire load_screen = load & addr_screen;
wire load_ram = load & addr_ram;

wire [15:0] out_screen;
wire [15:0] out_ram;
wire [15:0] out_keyboard;

always @* begin
    if (addr_ram)
        out = out_ram;
    else if (addr_screen)
        out = out_screen;
    else if (addr_keyboard)
        out = out_keyboard;
    else
        out = 16'h0000;
end


RAM16K ram
(
    .clk(clk),
    .in(in),
    .address(address[13:0]),
    .load(load_ram),
    .out(out_ram)
);

Screen screen
(
    .clk(clk),
    .reset(reset),

    .in(in),
    .address(address[12:0]),
    .load(load_screen),

    .out(out_screen),

    .video_color(video_color),
    .video_hsync(video_hsync),
    .video_vsync(video_vsync)
);

// TODO keyboard

endmodule
