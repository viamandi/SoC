/**
* Centralized Definitions for Constants and Signals Used Across the System
*/

`define DATA_BUS_LEN 32
`define FLASH_DATA_LEN 16

// ALU
`define ADD       3'b000             // Opcode for the addition operation in ALU.
`define SUB       3'b001             // Opcode for the subtraction operation in ALU.
`define AND       3'b010             // Opcode for the logical AND operation in ALU.
`define OR        3'b011             // Opcode for the logical OR operation in ALU.
`define XOR       3'b100             // Opcode for the XOR operation in ALU.
`define PASS_VAR1 3'b101             // Opcode to transfer the value of REG1 directly to ACCUMULATOR.
`define PASS_VAR2 3'b110             // Opcode to transfer the value of REG2 directly to ACCUMULATOR.
`define NOP       3'b111             // Opcode for the No Operation (NOP) instruction.

// REG 1 WR signal
`define REG1_WR 1'b1                 // Enable signal for writing data into REG1.
`define REG1_RD 1'b0                 // Enable signal for reading data into REG1.


// REG 2 WR signal
`define REG2_WR 1'b1                 // Enable signal for writing data into REG2.
`define REG2_RD 1'b0                 // Enable signal for reading data into REG2.

// RAM WR signal
`define RAM_WR 1'b1                  // Enable signal for writing data to RAM.
`define RAM_RD 1'b0                  // Enable signal for reading data from RAM.

// ALU LEFT INPUT input selector
`define MUX1_ALU_IN_SEL_REG1  2'b00  // Selects Register 1 as the left input for the ALU
`define MUX1_ALU_IN_SEL_REG2  2'b01  // Selects Register 2 as the left input for the ALU.
`define MUX1_ALU_IN_SEL_ALU   2'b10  // Feeds the ALU's accumulator output back as the left input for the ALU.
`define MUX1_ALU_IN_SEL_FLASH 2'b11  // Selects data from FLASH memory as the left input for the ALU.

// ALU RIGHT INPUT input selector
`define MUX2_ALU_IN_SEL_REG1  2'b00 // Selects Register 1 as the right input for the ALU
`define MUX2_ALU_IN_SEL_REG2  2'b01 // Selects Register 2 as the right input for the ALU.
`define MUX2_ALU_IN_SEL_ALU   2'b10 // Feeds the ALU's accumulator output back as the right input for the ALU.
`define MUX2_ALU_IN_SEL_FLASH 2'b11 // Selects data from FLASH memory as the right input for the ALU.


/************************************************************************************************************************/
// system instructions
/************************************************************************************************************************/
// Load data from FLASH memory into Register 1.
`define SYS_LD_R1_FROM_FLASH {`PASS_VAR1, `REG1_WR, `REG2_RD, `RAM_RD, `MUX1_ALU_IN_SEL_FLASH, `MUX2_ALU_IN_SEL_FLASH, 6'b0}
// Load data from FLASH memory into Register 2.
`define SYS_LD_R2_FROM_FLASH {`PASS_VAR2, `REG1_RD, `REG2_WR, `RAM_RD, `MUX1_ALU_IN_SEL_FLASH, `MUX2_ALU_IN_SEL_FLASH, 6'b0}

// Add a constant to Register 1.
`define SYS_R1_ADD_CONST {`ADD, `REG1_WR, `REG2_RD, `RAM_RD, `MUX1_ALU_IN_SEL_REG1, `MUX2_ALU_IN_SEL_FLASH, 6'b0}
// Add a constant to Register 2.
`define SYS_R2_ADD_CONST {`ADD, `REG1_RD, `REG2_WR, `RAM_RD, `MUX1_ALU_IN_SEL_FLASH, `MUX2_ALU_IN_SEL_REG2, 6'b0}

// Subtract a constant from Register 1.
`define SYS_R1_SUB_CONST {`SUB, `REG1_WR, `REG2_RD, `RAM_RD, `MUX1_ALU_IN_SEL_REG1, `MUX2_ALU_IN_SEL_FLASH, 6'b0}
// Subtract a constant from Register 2.
`define SYS_R2_SUB_CONST {`SUB, `REG1_RD, `REG2_WR, `RAM_RD, `MUX1_ALU_IN_SEL_FLASH, `MUX2_ALU_IN_SEL_REG2, 6'b0}

// load data (address you want to go for next instruction) into PC from flash instruction
`define SYS_LD_PC_FROM_INSTR {`PASS_VAR2, `REG1_RD, `REG2_RD, `RAM_RD, `MUX1_ALU_IN_SEL_REG1, `MUX1_ALU_IN_SEL_REG2, 6'b0}

// compare R1 with constant, if yes then go to PC + 2, go to PC + 1 (no branch, but go regular to next instruction);
`define SYS_R1_EQ_CONSTANT {`XOR, `REG1_RD, `REG2_RD, `RAM_RD, `MUX1_ALU_IN_SEL_REG1, `MUX2_ALU_IN_SEL_FLASH, 6'b0}

// No Operation, no data is changed in registers
`define SYS_NOP {`NOP, `REG1_RD, `REG2_RD, `RAM_RD, `MUX1_ALU_IN_SEL_REG1, `MUX1_ALU_IN_SEL_REG2, 6'b0}


/* extend functionality by define other operation*/
