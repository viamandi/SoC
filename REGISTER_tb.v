`include "MACROS.v"

`timescale 1ns / 1ps

module REGISTER_tb;

    // Testbench signals
    reg [`DATA_BUS_LEN-1:0] INPUT;  // Input data to the register
    reg WR;                        // Write enable signal
    reg CLK;                       // Clock signal
    reg RST;                       // Reset signal
    wire [`DATA_BUS_LEN-1:0] OUTPUT; // Output data from the register

    // Instantiate the REGISTER module
    REGISTER uut (
        .INPUT(INPUT),
        .OUTPUT(OUTPUT),
        .WR(WR),
        .CLK(CLK),
        .RST(RST)
    );

    // Clock generation
    initial begin
		$dumpfile("REGISTER_tb.vcd");       // Creates a waveform dump file for signal analysis.
        $dumpvars(5, REGISTER_tb);         // Dumps signal variables for debugging.
        CLK = 0;
        forever #5 CLK = ~CLK; // Toggle clock every 5ns
    end

    // Test sequence
    initial begin
        // Initialize signals
        INPUT = 0;
        WR = 0;
        RST = 1; // Activate reset
        #10;

        // Deactivate reset and check if register is cleared
        RST = 0;
        #10;
        if (OUTPUT !== 0) $display("Test failed: Reset did not clear the register.");

        // Write data to the register
        INPUT = 8'hA5; // Example data
        WR = 1; // Enable write
        #10;
        WR = 0; // Disable write
        #10;
        if (OUTPUT !== 8'hA5) $display("Test failed: Data was not written correctly.");

        // Write new data to the register
        INPUT = 8'h3C;
        WR = 1;
        #10;
        WR = 0;
        #10;
        if (OUTPUT !== 8'h3C) $display("Test failed: Data was not updated correctly.");

        // Activate reset again
        RST = 1;
        #10;
        RST = 0;
        #10;
        if (OUTPUT !== 0) $display("Test failed: Reset did not clear the register after writing data.");

        // End simulation
        $display("All tests completed.");
        $finish;
    end

endmodule