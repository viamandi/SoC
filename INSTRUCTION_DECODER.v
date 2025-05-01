/**
* Extracts and decodes information from FLASH memory to generate control signals for corresponding SoC modules
*
* INSTRUCTION: Encodes the operation to be performed. It includes the opcode and possibly additional data
               such as constants or address offsets.
* ALU_OPERATION: Maps to a specific function of the Arithmetic Logic Unit, such as addition, subtraction,
                 AND, OR, etc.
* REG1_WR and REG2_WR: Control whether new data can be written into Register 1 or Register 2. These are
                       often set by specific instructions that modify register contents.
* RAM_WR and RAM_RD: Enable writing or reading from the RAM. These signals ensure data transfer occurs
                     only when the appropriate instruction is executed.
* MUX_ALU_IN_LEFT and MUX_ALU_IN_RIGHT: These determine the source of inputs for the ALU, such as data
                                        from a register, immediate values, or RAM.
* DATA: This output extracts the lower 16 bits of the INSTRUCTION. It is often used in operations that
        involve immediate values, such as loading a constant into a register or performing arithmetic with
        a specified constant.
*/

module INSTRUCTION_DECODER(
 input  [31:0] INSTRUCTION,      // 32-bit encoded instruction to be decoded.
 output [ 2:0] ALU_OPERATION,    // Specifies the arithmetic or logical operation for the ALU.
 output        REG1_WR,          // Write enable signal for Register 1.
 output        REG2_WR,          // Write enable signal for Register 2.
 output        RAM_WR,           // Write enable signal for RAM.
 output        RAM_RD,           // Read enable signal for RAM.
 output [ 1:0] MUX_ALU_IN_LEFT,  // Select signal for the left input of the ALU multiplexer.
 output [ 1:0] MUX_ALU_IN_RIGHT, // Select signal for the right input of the ALU multiplexer.
 output [15:0] DATA              // Contains data derived from the immediate value in the instruction.
 );

 reg    [ 2:0] ALU_OPERATION;
 reg           REG1_WR;
 reg           REG2_WR;
 reg           RAM_WR;
 reg    [ 1:0] MUX_ALU_IN_LEFT;
 reg    [ 1:0] MUX_ALU_IN_RIGHT;
 reg    [15:0] DATA;

 always @(INSTRUCTION) begin
  ALU_OPERATION    <= INSTRUCTION[31:29];
  REG1_WR          <= INSTRUCTION[   28];
  REG2_WR          <= INSTRUCTION[   27];
  RAM_WR           <= INSTRUCTION[   26];
  MUX_ALU_IN_LEFT  <= INSTRUCTION[25:24];
  MUX_ALU_IN_RIGHT <= INSTRUCTION[23:22];
  DATA             <= INSTRUCTION[15: 0];
 end
endmodule
