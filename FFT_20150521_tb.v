`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: MSIS LAB
// Engineer: Hossam Hassan
//
// Create Date:   18:32:50 05/21/2015
// Design Name:   FFT_20150521
// Module Name:   D:/01_PhD_Studies/05_MSIS_Projects/01_Touch_Screen/01_FFT_Design/FFT_20150521/FFT_20150521_tb.v
// Project Name:  FFT_20150521
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FFT_20150521
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FFT_20150521_tb;

	// Inputs
	reg clk;
	reg reset;
	reg [15:0] xr_in;
	reg [15:0] xi_in;
	reg [15:0] xr_in_test [255:0]; //Memory to Save Real Data
	reg [15:0] xi_in_test [255:0]; //Memory to Save Imag. Data
	reg [ 8:0] counter;
	// Outputs
	wire fft_valid;
	wire signed  [15:0] fftr;
	wire signed  [15:0] ffti;
	wire [8:0] rcount_o;
	wire [15:0] xr_out0;
	wire [15:0] xi_out0;
	wire [15:0] xr_out1;
	wire [15:0] xi_out1;
	wire [15:0] xr_out255;
	wire [15:0] xi_out255;
	wire [8:0] stage_o;
	wire [8:0] gcount_o;
	wire [8:0] i1_o;
	wire [8:0] i2_o;
	wire [8:0] k1_o;
	wire [8:0] k2_o;
	wire [8:0] w_o;
	wire [8:0] dw_o;
	wire [8:0] wo;

	// Instantiate the Unit Under Test (UUT)
	FFT_20150521 uut (
		.clk(clk), 
		.reset(reset), 
		.xr_in(xr_in), 
		.xi_in(xi_in), 
		.fft_valid(fft_valid), 
		.fftr(fftr), 
		.ffti(ffti), 
		.rcount_o(rcount_o), 
		.xr_out0(xr_out0), 
		.xi_out0(xi_out0), 
		.xr_out1(xr_out1), 
		.xi_out1(xi_out1), 
		.xr_out255(xr_out255), 
		.xi_out255(xi_out255), 
		.stage_o(stage_o), 
		.gcount_o(gcount_o), 
		.i1_o(i1_o), 
		.i2_o(i2_o), 
		.k1_o(k1_o), 
		.k2_o(k2_o), 
		.w_o(w_o), 
		.dw_o(dw_o), 
		.wo(wo)
	);

always 	
# 10 clk <= ~clk;
initial
begin
$readmemh("xr_in.txt", xr_in_test);//Reading xr_in Values 
$readmemh("xi_in.txt", xi_in_test);//Reading xi_in Values 
end

//for Simulation log
//integer FFT_Real, FFT_Imag;
integer FFT_Results;

always @ (fftr or ffti)
begin
if (reset) 
	begin 
//	FFT_Real = $fopen("FFT_Real.txt","w");
//	FFT_Imag = $fopen("FFT_Imag.txt","w");
	FFT_Results = $fopen("FFT_Results.txt","w");
	$fdisplay(FFT_Results, " FFT_Real ; FFT_Imag ");	
	end
else
	begin
	$fdisplay(FFT_Results," %d; %d ; ",  fftr ,ffti);  
	end
end	
always @ (negedge clk or posedge reset)
begin
if (reset == 1) 
	begin 	
	xr_in 	<= 0;
	xi_in 	<= 0;
	counter 	<= 0;
	end 
else 				 
	begin
	if (counter == 256)
		counter  <= counter;
	else
		begin
		xr_in <= xr_in_test[counter];
		xi_in <= xi_in_test[counter];
		counter <= counter +1;
		end
	end
end
initial 
	begin
	// Initialize Inputs
	clk 		= 0;
	reset 	= 1;
	counter 	= 0;
	xr_in 	= 0;
	xi_in 	= 0;
	#10 reset = 0;
	end
      
endmodule

