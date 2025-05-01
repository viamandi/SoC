/**
* Simulation of the SoC.
* It performs a "for" instruction, to multiply the 7 with 7. So in the end the result in
* R2 is 49 decimal (or 31 as hexa value)
*/

`include "MACROS.v" // Include macro definitions for constants and signals used in the testbench.

module test;

    // Define registers for FLASH memory and control signals
    reg[`DATA_BUS_LEN-1:0] FLASH_IN;   // Data input for FLASH memory programming.
    reg[`DATA_BUS_LEN-1:0] FLASH_ADDR; // Address for accessing FLASH memory locations.
    reg FLASH_WR, RST, CLK;            // Control signals for FLASH write, system reset, and clock.

    // Instantiate the SystemOnChip module
    SystemOnChip SoC(
        .FLASH_IN(FLASH_IN),         // Connects the FLASH data input to the SoC.
        .FLASH_ADDR(FLASH_ADDR),     // Connects the FLASH address input to the SoC.
        .FLASH_WR(FLASH_WR),         // Connects the FLASH write enable signal to the SoC.
        .RST(RST),                   // Connects the reset signal to the SoC.
        .CLK(CLK)                    // Connects the clock signal to the SoC.
    );

    // Simulate FLASH programming and system reset
    initial begin
        RST = 0; // Ensure system is not in reset mode.

        // Load instructions into FLASH memory
        #20 FLASH_WRITE_INSTRUCTION({`SYS_LD_R1_FROM_FLASH, `FLASH_DATA_LEN'h7}, 32'h0); // Load 7 into Register 1.
        #20 FLASH_WRITE_INSTRUCTION({`SYS_LD_R2_FROM_FLASH, `FLASH_DATA_LEN'h0}, 32'h1); // Load 0 into Register 2.
        #20 FLASH_WRITE_INSTRUCTION({`SYS_R2_ADD_CONST, `FLASH_DATA_LEN'h7}, 32'h2);     // Add 7 to Register 2.
        #20 FLASH_WRITE_INSTRUCTION({`SYS_R1_SUB_CONST, `FLASH_DATA_LEN'h1}, 32'h3);     // Subtract 1 from Register 1.
        #20 FLASH_WRITE_INSTRUCTION({`SYS_R1_EQ_CONSTANT, `FLASH_DATA_LEN'h0}, 32'h4);   // Compare R1 with 0.
        #20 FLASH_WRITE_INSTRUCTION({`SYS_LD_PC_FROM_INSTR, `FLASH_DATA_LEN'h2}, 32'h5); // Conditional jump to line 2.
        #20 FLASH_WRITE_INSTRUCTION({`SYS_NOP, `FLASH_DATA_LEN'h0}, 32'h6);              // No operation.
        #20 FLASH_WRITE_INSTRUCTION({`SYS_NOP, `FLASH_DATA_LEN'h0}, 32'h7);              // No operation.
        #20 FLASH_WRITE_INSTRUCTION({`SYS_NOP, `FLASH_DATA_LEN'h0}, 32'h8);              // No operation.
        #20 FLASH_WRITE_INSTRUCTION({`SYS_NOP, `FLASH_DATA_LEN'h0}, 32'h9);              // No operation.

        #1000 // Pause before resetting the system.

        FLASH_WR = 0; // Disable FLASH write operation.
        RST = 1;      // Reset the system.

        #35 RST = 0;  // Release the reset signal.
        #1000 $finish; // End the simulation.
    end

    // Generate a clock signal
    initial begin
        $dumpfile("test.vcd");       // Creates a waveform dump file for signal analysis.
        $dumpvars(20, test);         // Dumps signal variables for debugging.
        CLK = 1;                     // Initialize the clock signal.
        RST = 0;                     // Ensure reset signal is inactive.
        forever #10 CLK = ~CLK;      // Toggle clock signal every 10 units.
    end

    // Task to write instructions into FLASH memory
    task FLASH_WRITE_INSTRUCTION;
        input [`DATA_BUS_LEN-1 : 0] flash_in;   // Instruction data for FLASH.
        input [`DATA_BUS_LEN-1 : 0] flash_addr; // Address in FLASH memory.
        begin
            FLASH_WR = 1'b1;          // Enable FLASH write operation.
            FLASH_IN = flash_in;      // Assign instruction data to FLASH input.
            FLASH_ADDR = flash_addr;  // Assign address to FLASH memory input.
        end
    endtask

    // Monitor signals and FLASH memory during simulation
    initial begin
        #1850
        if (test.SoC.flash.OUT == {`SYS_NOP, 16'h0}) begin
            if (test.SoC.processor.REG1_OUT != 0) begin
                $display("ERROR: R1 is not 0, it is %h", test.SoC.processor.REG1_OUT); // Check if R1 is zero.
            end else if (test.SoC.processor.REG2_OUT != 49) begin
                $display("ERROR: R2 is not 49, it is %h", test.SoC.processor.REG2_OUT); // Check if R2 is 49.
            end else begin
                $display("SUCCESS: R1 = %h, R2 = %h", test.SoC.processor.REG1_OUT, test.SoC.processor.REG2_OUT); // Display success message.
            end
        end else begin
            $display("ERROR: FLASH memory is not programmed correctly, it is %h", test.SoC.flash.OUT); // Check FLASH memory content.
            $display("ERROR: Shall be %h", {`SYS_NOP, 16'h0}); // Check FLASH memory content.
        end
    end

endmodule
