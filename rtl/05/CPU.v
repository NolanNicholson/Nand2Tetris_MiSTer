module CPU
(
    input clk,

    input [15:0] instruction,
    input [15:0] inM,
    input reset,

    output [15:0] outM,
    output [14:0] addressM,
    output writeM,
    output [14:0] pc
);

endmodule
