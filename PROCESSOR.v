/**
* Central Processing Module Coordinating Data Flow and Operations Across the System
*/
`include "MACROS.v" // Include macro definitions for constants and signals used in the processor module.

module PROCESSOR(CLK, RST, FLASH_INSTR_IN, FLASH_ADDR_OUT, RAM_DATA_IN, RAM_DATA_OUT, RAM_ADDR);

    // Clock and Reset signals
    input wire CLK;                 // Clock signal for synchronizing operations.
    input wire RST;                 // Reset signal to initialize or reset the processor state.

    // FLASH memory interface
    input wire[`DATA_BUS_LEN-1:0] FLASH_INSTR_IN;  // Instruction fetched from FLASH memory.
    output wire[`DATA_BUS_LEN-1:0] FLASH_ADDR_OUT; // Address to fetch the next instruction from FLASH memory.

    // RAM memory interface
    input wire[`DATA_BUS_LEN-1:0] RAM_DATA_IN;  // Data input for the RAM module.
    input wire[`DATA_BUS_LEN-1:0] RAM_DATA_OUT; // Data output from the RAM module.
    input wire[`DATA_BUS_LEN-1:0] RAM_ADDR;     // Address bus for accessing RAM locations.

    // Internal connections and registers
    wire [`DATA_BUS_LEN-1:0] ACC;               // Accumulator for storing results from ALU operations.
    wire [`DATA_BUS_LEN-1:0] REG1_IN, REG1_OUT; // Register 1: input and output data.
    wire [`DATA_BUS_LEN-1:0] REG2_IN, REG2_OUT; // Register 2: input and output data.
    wire [`DATA_BUS_LEN-1:0] ALU_VAR1_IN;       // First operand for ALU operations.
    wire [`DATA_BUS_LEN-1:0] ALU_VAR2_IN;       // Second operand for ALU operations.

    // Control signals and decoded outputs
    wire [2:0] OPCODE;                          // Operation code for the ALU.
    wire REG1_WR;                               // Write enable signal for Register 1.
    wire REG2_WR;                               // Write enable signal for Register 2.
    wire RAM_WR;                                // Write enable signal for RAM.
    wire [1:0] MUX_ALU_IN_LEFT;                 // Selector signal for ALU left input multiplexer.
    wire [1:0] MUX_ALU_IN_RIGHT;                // Selector signal for ALU right input multiplexer.
    wire [15:0] DATA;                           // Data extracted from instructions.

    // Instruction decoder module
    INSTRUCTION_DECODER INSTRUCTION_DECODER_INSTANCE(
        .INSTRUCTION(FLASH_INSTR_IN),          // Pass instruction from FLASH memory to decoder.
        .ALU_OPERATION(OPCODE),                // Extract ALU operation code.
        .REG1_WR(REG1_WR),                     // Extract write enable signal for Register 1.
        .REG2_WR(REG2_WR),                     // Extract write enable signal for Register 2.
        .RAM_WR(RAM_WR),                       // Extract write enable signal for RAM.
        .MUX_ALU_IN_LEFT(MUX_ALU_IN_LEFT),     // Extract selector for ALU left input multiplexer.
        .MUX_ALU_IN_RIGHT(MUX_ALU_IN_RIGHT),   // Extract selector for ALU right input multiplexer.
        .DATA(DATA)                            // Extract immediate data from instruction.
    );

    // Register Modules
    REGISTER REG1(.INPUT(ACC), .OUTPUT(REG1_OUT), .WR(REG1_WR), .CLK(CLK), .RST(RST)); // Register 1 for general-purpose use.
    REGISTER REG2(.INPUT(ACC), .OUTPUT(REG2_OUT), .WR(REG2_WR), .CLK(CLK), .RST(RST)); // Register 2 for general-purpose use.

    // Multiplexers for ALU input selection
    MUX MUX_REG1_IN(.IN0(REG1_OUT), .IN1(REG2_OUT), .IN2(ACC), .IN3({16'b0, DATA}), .SEL(MUX_ALU_IN_LEFT), .OUT(ALU_VAR1_IN)); // ALU left input multiplexer.
    MUX MUX_REG2_IN(.IN0(REG1_OUT), .IN1(REG2_OUT), .IN2(ACC), .IN3({16'b0, DATA}), .SEL(MUX_ALU_IN_RIGHT), .OUT(ALU_VAR2_IN)); // ALU right input multiplexer.

    // Equality check for conditional branching
    wire EQ = |ACC; // Checks if ACC equals zero for branch instructions.

    // Program Counter (PC) for instruction flow
    reg [`DATA_BUS_LEN-1:0] PC; // Holds the address of the current instruction.

    // Program Counter update logic
    always @(negedge CLK or posedge RST) begin
        if (RST == 1) begin
            PC <= 0; // Reset PC to 0 on system reset.
        end else begin
            if ({FLASH_INSTR_IN[31:16]} == `SYS_R1_EQ_CONSTANT && EQ == 0) // Conditional branch if ACC is zero.
                PC <= PC + 2;
            else if (FLASH_INSTR_IN[31:16] == `SYS_LD_PC_FROM_INSTR) // Load PC directly from instruction.
                PC <= DATA;
            else
                PC <= PC + 1; // Increment PC to fetch the next instruction.
        end
    end

    assign FLASH_ADDR_OUT = PC; // Connect PC to FLASH address output.

    // ALU module for performing arithmetic and logical operations
    ALU ALU_INSTANCE(.ALU_OPERATION(OPCODE), .VAR1(ALU_VAR1_IN), .VAR2(ALU_VAR2_IN), .ACCUMULATOR(ACC));

endmodule
