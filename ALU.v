`include "MACROS.v"

/**
* Make logical operations between 2 operands, e.g. add, or, and, xor, etc
*
* ALU_OPERATION: This is a 3-bit signal used to identify the specific arithmetic or
*                logical operation to be executed by the ALU. Examples include:
*   000: Addition
*   001: Subtraction
*   010: Logical AND
*   011: Logical OR
*   100: XOR
*   101: Transfer VAR1 value
*   110: Transfer VAR2 value
*   111: No operation (NOP)
*   VAR1 and VAR2: These inputs represent the operands for the ALU operation. 
*             VAR1 is typically the left operand and VAR2 the right operand,
*             but the specific usage depends on the operation being performed.
*
* ACCUMULATOR: The output of the ALU, this register holds the result of the operation.
*           It can be used as an intermediate value for subsequent calculations or as
*           a final output.
*/
module ALU (
 input      [              2:0] ALU_OPERATION, // Specifies the operation to be performed by the ALU (e.g., addition, subtraction, AND, OR, etc.).
 input      [`DATA_BUS_LEN-1:0] VAR1,          // The first input operand for the operation.
 input      [`DATA_BUS_LEN-1:0] VAR2,          // The second input operand for the operation.
 output reg [`DATA_BUS_LEN-1:0] ACCUMULATOR    // Stores the result of the operation performed by the ALU.
);
    always @(VAR1 or VAR2 or ALU_OPERATION) begin
        case (ALU_OPERATION)
            3'b000: ACCUMULATOR <= VAR1 + VAR2;
            3'b001: ACCUMULATOR <= VAR1 - VAR2;
            3'b010: ACCUMULATOR <= VAR1 & VAR2;
            3'b011: ACCUMULATOR <= VAR1 | VAR2;
            3'b100: ACCUMULATOR <= VAR1 ^ VAR2;
            3'b101: ACCUMULATOR <= VAR1;
            3'b110: ACCUMULATOR <= VAR2;
            3'b111: ACCUMULATOR <= ACCUMULATOR;
            default: ACCUMULATOR <= ACCUMULATOR;
        endcase
    end
endmodule

