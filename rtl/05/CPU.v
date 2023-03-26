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

// A-instruction versus C-instruction
wire is_c = instruction[15];
wire [15:0] a_in = is_c ? alu_out : instruction;

// C-instruction decoding:
//  * Bit 15 is 1 for C-instruction, 0 for A-instruction
//  * Bits 14, 13 not used
//  * Bit 12 determines whether M or A is used in ALU comp
//  * Bits 11-6 specify ALU comp
//  * Bits 5-3 specify where to store ALU instruction
//  * Bits 2-0 specify jump criterion

wire [15:0] M_or_A = instruction[12] ? inM : A;
assign writeM = is_c & instruction[3];
wire writeD = is_c & instruction[4];

// A is written when bit 3 of a C-instruction is set,
// but also for ALL A-instructions.
wire writeA = (is_c & instruction[5]) | ~is_c;

// Registers
reg [15:0] A = 16'h0000;
reg [15:0] D = 16'h0000;
reg [15:0] PC_reg = 16'h0000;

always @(posedge clk) begin
    // A register
    if (writeA) begin
        A <= a_in;
    end

    // D register
    if (writeD) begin
        D <= alu_out;
    end

    // Program counter
    if (reset) begin
        PC_reg <= 0;
    end else if (pc_jmp) begin
        PC_reg <= A;
    end else begin
        PC_reg <= PC_reg + 16'h0001;
    end
end

assign pc = PC_reg[14:0];
assign addressM = A[14:0];
assign outM = alu_out;

wire [15:0] alu_out;
wire alu_zr;
wire alu_ng;

ALU alu
(
   .x(D),
   .y(M_or_A),
   .out(alu_out),

   .zx(instruction[11]),
   .nx(instruction[10]),
   .zy(instruction[ 9]),
   .ny(instruction[ 8]),
   .f (instruction[ 7]),
   .no(instruction[ 6]),

   .zr(alu_zr),
   .ng(alu_ng)
);

// Jump determination based on jmp bits and ALU output.
// But also, we don't ever jump on an A-instruction.
wire jmp_neg  = instruction[2] & alu_ng;
wire jmp_zero = instruction[1] & alu_zr;
wire jmp_pos  = instruction[0] & ~alu_zr & ~alu_ng;
wire pc_jmp = is_c & (jmp_neg | jmp_zero | jmp_pos);

endmodule
