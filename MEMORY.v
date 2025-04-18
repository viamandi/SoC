/**
* Modules and Interfaces for RAM and FLASH Memory Operations in the System
*
* ADDR: The address bus specifies which memory location in RAM is to be accessed, using the defined width (DATA_BUS_LEN).
* IN: The input data to be stored in the RAM location specified by ADDR, activated when the write signal (WR) is enabled.
* WR: The control signal that allows data to be written into the memory. When WR = 1, the data from IN is stored in the location specified by ADDR.
* CLK: Synchronizes write operations to ensure data integrity during writing into the ram/flash.
* OUT: The data read from the memory location specified by ADDR. This is used when performing a read operation.
*/
module MEMORY(ADDR, OUT, IN, WR, CLK);
    input  [`DATA_BUS_LEN-1:0] ADDR;  // Address bus for accessing specific memory locations in RAM/FLASH. (for simple implementation use the same module for ram and flash)
    output [`DATA_BUS_LEN-1:0] OUT;   // Data bus for output data read from RAM/FLASH.
    input  [`DATA_BUS_LEN-1:0] IN;    // Data bus for input data to be written into RAM/FLASH.
    input                      WR;    // Write enable signal for controlling write operations.
    input                      CLK;   // Clock signal for synchronizing write operations.
 
    reg    [`DATA_BUS_LEN-1:0] OUT;

    // Memorie RAM simulată (256 locații de 32 de biți)
    reg [`DATA_BUS_LEN-1:0] memory [0:255];

    always @(posedge CLK) begin
        if (WR == 1 && CLK == 1) begin
            memory[ADDR] <= IN;
        end
    end

    always @(ADDR) begin
        OUT <= memory[ADDR];
    end
endmodule
