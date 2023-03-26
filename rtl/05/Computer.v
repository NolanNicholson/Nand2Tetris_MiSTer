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


wire [15:0] cpu_instruction;
wire [15:0] cpu_inM /*verilator public_flat*/;
wire [15:0] cpu_outM /*verilator public_flat*/;
wire [14:0] cpu_addressM /*verilator public_flat*/;
wire cpu_writeM /*verilator public_flat*/;
wire [14:0] cpu_pc;

CPU cpu
(
    .clk(clk),

    .instruction(cpu_instruction),
    .inM(cpu_inM),
    .reset(reset),

    .outM(cpu_outM),
    .addressM(cpu_addressM),
    .writeM(cpu_writeM),
    .pc(cpu_pc)
);

ROM32K prog_mem
(
    .address(cpu_pc),
    .out(cpu_instruction),

    .clk(clk),
    .ioctl_addr(ioctl_addr),
    .ioctl_din(ioctl_din),
    .ioctl_wr(ioctl_wr)
);

Memory memory
(
    .clk(clk),
    .reset(reset),

    .in(cpu_outM),
    .address(cpu_addressM),
    .load(cpu_writeM),

    .out(cpu_inM),

    .video_color(video_color),
    .video_hsync(video_hsync),
    .video_vsync(video_vsync)
);


endmodule
