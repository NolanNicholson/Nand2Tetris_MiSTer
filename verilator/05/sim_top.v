`timescale 1ns/1ns
// top end ff for verilator

module top
(
    input clk_48 /*verilator public_flat*/,
    input clk_12 /*verilator public_flat*/,
    input reset /*verilator public_flat*/,
    input [11:0]  inputs/*verilator public_flat*/,

    output [7:0] VGA_R/*verilator public_flat*/,
    output [7:0] VGA_G/*verilator public_flat*/,
    output [7:0] VGA_B/*verilator public_flat*/,

    output VGA_HS,
    output VGA_VS,
    output VGA_HB,
    output VGA_VB,

    output [15:0] AUDIO_L,
    output [15:0] AUDIO_R,

    input        ioctl_download,
    input        ioctl_upload,
    input        ioctl_wr,
    input [24:0] ioctl_addr,
    input [7:0]  ioctl_dout,
    input [7:0]  ioctl_din,   
    input [7:0]  ioctl_index,
    output  reg  ioctl_wait=1'b0

);

// Core inputs/outputs
wire video_color;
wire [15:0] keyboard = 16'h0000; // TODO

// Convert 1bpp output to 8bpp
assign VGA_R = video_color ? 8'h00 : 8'hFF;
assign VGA_G = video_color ? 8'h00 : 8'hFF;
assign VGA_B = video_color ? 8'h00 : 8'hFF;

// We don't need blanking signals - sync alone suffices
assign VGA_HB = 0;
assign VGA_VB = 0;

// Audio not used
assign AUDIO_L = 16'h0000;
assign AUDIO_R = 16'h0000;

Computer computer
(
    .clk(clk_12),
    .reset(reset),
    .keyboard(16'h0000), // TODO

    .video_color(video_color),
    .video_hsync(VGA_HS),
    .video_vsync(VGA_VS),

    .ioctl_addr(ioctl_addr[15:0]),
    .ioctl_din(ioctl_din),
    .ioctl_wr(ioctl_wr)
);

endmodule
