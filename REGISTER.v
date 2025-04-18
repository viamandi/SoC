/**
* Module for Storing and Managing Data with Synchronized Write and Reset Capabilities
*
* INPUT: The data that is written into the register when the WR signal is active.
* WR: A control signal; it must be high to allow the input data to be written to the register.
* CLK: Synchronizes operations with the clock's rising edge (posedge).
* RST: Clears the register and sets its value to zero when active.
* OUTPUT: Provides the stored value for use by other components in the system.
*/

module REGISTER(INPUT, OUTPUT, WR, CLK, RST);

    // Define inputs and outputs of the register
    input [`DATA_BUS_LEN-1:0] INPUT;  // Data input to be stored in the register.
    input WR;                        // Write enable signal; allows data to be written to the register.
    input CLK;                       // Clock signal for synchronizing operations.
    input RST;                       // Reset signal; clears the register to zero.

    output [`DATA_BUS_LEN-1:0] OUTPUT; // Data output; provides the stored value from the register.
    reg [`DATA_BUS_LEN-1:0] OUTPUT;   // Register to hold the value internally.

    // Always block to handle register operations
    always @(posedge CLK) begin
        if (RST)                      // If reset signal is active...
            OUTPUT <= 0;              // ...set the register value to zero.
        else if (WR)                  // If write enable signal is active...
            OUTPUT <= INPUT;          // ...store the input value in the register.
    end
endmodule