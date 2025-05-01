# SystemOnChip Project

# Overview
The **SystemOnChip (SoC)** project integrates multiple hardware modules, such as a processor, memory units, multiplexers, and control logic, into a cohesive design. This system is designed for efficient instruction execution and data handling. The following documentation outlines its functionality, structure, and usage.

# Modules
**1. Processor**
Handles instruction execution, arithmetic and logical operations, and data management. It interacts with FLASH and RAM memory for fetching instructions and processing data.

**2. Memory Units**
FLASH Memory: Stores instructions and supports both read and write operations.

**3. Multiplexer (MUX)**
Dynamic signal routing based on control inputs.

**4. Registers**
Intermediate storage for computation results, with synchronized read/write operations.

# Setup: Installing and Running the System
## Prerequisites
Ensure the following software is installed on your Windows or Linux system:

**1.** Git: Version control system for cloning repositories.

**2.** MinGW: Minimalist GNU for Windows to provide the make tool.

**3.** Icarus Verilog: Tool for compiling Verilog code.

**4.** GTKWave: Waveform viewer for analyzing .vcd files.

# Building and simulate the System
* **Clean the Build Environment** Removes any previous build artifacts to ensure a fresh compilation.
    * make clean
* **Compile the System** Compiles the Verilog files into an executable.
    * make
* **Run the Simulation** Executes the compiled design to generate output.
    * make run
* **Analyze Signals** Opens the waveform file (signals.vcd) in GTKWave for debugging and analysis.
    * make signal
