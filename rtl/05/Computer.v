module Computer
(
    input clk,
    input reset,
    input [15:0] keyboard,

    // Not part of original Hack specification.
    // Passthrough for Screen's video.
    output video_color,
    output video_hsync,
    output video_vsync,

    // Not part of original Hack specification. These signals allow us to use
    // the MiSTer's IOCTL interface to write to our instruction ROM.
    input [15:0] ioctl_addr,
    input [7:0] ioctl_din,
    input ioctl_wr
);


Memory memory
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

CPU cpu
(
    .clk(clk),

    // TODO
    .instruction(),
    .inM(),
    .reset(reset),

    // TODO
    .outM(),
    .addressM(),
    .writeM(),
    .pc()
);


endmodule
