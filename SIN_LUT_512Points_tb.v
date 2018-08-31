`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: MSIS LAB
// Engineer: Hossam Hassan
//
// Create Date:   20:55:00 05/27/2015
// Design Name:   SIN_LUT_512Points
// Module Name:   D:/01_PhD_Studies/05_MSIS_Projects/01_Touch_Screen/01_FFT_Design/FFT_20150521/SIN_LUT_512Points_tb.v
// Project Name:  FFT_20150521
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SIN_LUT_512Points
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module SIN_LUT_512Points_tb;
parameter HALF_PERIOD = 10;
	// Inputs
	reg Clk;
	reg [9:0] addr;
	reg reset;

	// Outputs
	wire [17:0] Dout;

	// Instantiate the Unit Under Test (UUT)
	SIN_LUT_512Points uut (
		.Clk(Clk), 
		.addr(addr), 
		.Dout(Dout), 
		.reset(reset)
	);
	initial begin :CLK_GENERATOR
		Clk = 0;
		forever begin
			#HALF_PERIOD 
			Clk = ~Clk;
		end
	end

	initial begin
		// Initialize Inputs
		Clk = 0;
		addr = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		#HALF_PERIOD
		reset = 0;
		addr = 20;
		#20
		addr = 30;
		#20
		addr = 70;
	end
      
endmodule

