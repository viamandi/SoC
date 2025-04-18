# Makefile for compiling project and running Verilog simulations

# Default target to compile the Verilog code and generate the executable
all: a.out

#Compiles all Verilog files into an executable named 'a.out'
a.out: *.v
	iverilog -o a.out $^

#Runs the compiled simulation executable
run: a.out
	vvp a.out

#Opens GTKWave to visualize the testbench signals
signal:
	gtkwave test.vcd

#Removes all '.out' and '.vcd' files to clean the directory
clean:
	rm -f *.out *.vcd