/**
* Integrates the processor, memory modules, and control logic to enable the execution of instructions and management of data flow.
*
* Fetches instructions from FLASH memory using the Program Counter (PC).
* Provides a mechanism to program FLASH memory through the FLASH_WR signal.
* Accesses and modifies data in RAM during runtime operations.
* Synchronizes all components with a unified clock signal (CLK).
*/
module SystemOnChip(FLASH_IN, FLASH_ADDR, FLASH_WR, RST, CLK);

    // SystemOnChip Module: Integrates processor, memory, and control logic for data and instruction flow.

    // Inputs
    input wire [`DATA_BUS_LEN-1:0] FLASH_IN;       // Input data for FLASH memory (used for programming instructions).
    input wire [`DATA_BUS_LEN-1:0] FLASH_ADDR;    // Address for accessing FLASH memory during programming.
    input wire FLASH_WR;                          // Write enable signal for FLASH memory programming.
    input wire CLK;                               // Clock signal to synchronize operations across the system.
    input wire RST;                               // Reset signal to initialize or reset the system.

    // Internal Signals
    wire [`DATA_BUS_LEN-1:0] PC;                  // Program Counter for fetching instruction addresses from FLASH memory.
    wire [`DATA_BUS_LEN-1:0] FLASH_ADDR_IN;       // Address input for the FLASH memory.
    wire [`DATA_BUS_LEN-1:0] flash_out;           // Data output from the FLASH memory (fetched instructions).
    wire [`DATA_BUS_LEN-1:0] RAM_ADDR;            // Address bus for accessing data in RAM.
    wire [`DATA_BUS_LEN-1:0] RAM_DATA_OUT;        // Data read from RAM.
    wire [`DATA_BUS_LEN-1:0] RAM_DATA_IN;         // Data to be written into RAM.
    wire WR;                                      // Write enable signal for RAM operations.

    // Multiplexer for FLASH Address Selection
    // Selects between PC (instruction fetching) and FLASH_ADDR (programming) based on the FLASH_WR signal.
    MUX mux_flash_in(
        .IN0(PC), 
        .IN1(FLASH_ADDR), 
        .IN2(`DATA_BUS_LEN'hz), 
        .IN3(`DATA_BUS_LEN'hz), 
        .SEL({1'b0, FLASH_WR}), 
        .OUT(FLASH_ADDR_IN)
    );

    // FLASH Memory Instance
    // Handles instruction storage and retrieval.
    MEMORY flash(
        .ADDR(FLASH_ADDR_IN),   // Address input for fetching or programming FLASH memory.
        .OUT(flash_out),        // Instruction data output from FLASH memory.
        .IN(FLASH_IN),          // Instruction data input for FLASH programming.
        .WR(FLASH_WR),          // Write enable signal for programming FLASH memory.
        .CLK(CLK)               // Clock signal for synchronizing FLASH operations.
    );

    // RAM Instance
    // Handles data storage and retrieval for runtime operations.
    MEMORY ram(
        .ADDR(RAM_ADDR),        // Address input for accessing specific data locations in RAM.
        .OUT(RAM_DATA_OUT),     // Data output from RAM (read operations).
        .IN(RAM_DATA_IN),       // Data input to RAM (write operations).
        .WR(WR),                // Write enable signal for RAM operations.
        .CLK(CLK)               // Clock signal for synchronizing RAM operations.
    );

    // Processor Instance
    // Orchestrates instruction execution and manages data flow.
    PROCESSOR processor(
        .CLK(CLK), 
        .RST(RST), 
        .FLASH_INSTR_IN(flash_out),    // Instruction input from FLASH memory.
        .FLASH_ADDR_OUT(PC),           // Program Counter output for fetching instructions.
        .RAM_DATA_IN(RAM_DATA_IN),     // Data input from RAM.
        .RAM_DATA_OUT(RAM_DATA_OUT),   // Data output to RAM.
        .RAM_ADDR(RAM_ADDR)            // Address output for RAM access.
    );
endmodule
