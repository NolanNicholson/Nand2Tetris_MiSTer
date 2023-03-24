module Memory
(
    input clk,
    input reset,

    input [15:0] in,
    input [14:0] address,
    input load,
    output [15:0] out,

    // Not part of original Hack specification.
    // Passthrough for Screen's video.
    output video_color,
    output video_hsync,
    output video_vsync
);

Screen screen
(
    .clk(clk),
    .reset(reset),

    // TODO
    .in(),
    .address(),
    .load(),

    // TODO
    .out(),

    .video_color(video_color),
    .video_hsync(video_hsync),
    .video_vsync(video_vsync)
);

endmodule
