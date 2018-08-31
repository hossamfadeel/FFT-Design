`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MSIS LAB
// Engineer: Hossam Hassan
// 
// Create Date:    14:37:16 05/27/2015 
// Design Name: 
// Module Name:    FFT_20150527 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
/*
 Implements a butterfly module for a FFT.
  Radix 2, Decimation In Frequency (DIF)
					YA =  XA + XB
					YB = (XA - XB) * W
						OR
					y0 =  x0 + x1  
					y1 = (x0 - x1) W
 				W  =  exp(-j*2*pi*k*(n/N))
 */
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FFT_20150527
//=============================================================================	
//========================= Parameters Declarations ===========================		
//=============================================================================
#(
 // The width of the input, output and twiddle factors.
 parameter DataWidth = 16
 )
//=============================================================================
//========================   Inputs Declarations   ============================
//=============================================================================
(
input  wire                        clk,// System clock
input  wire                        reset,// Asynchronous reset
input  wire                        Start,// Start Butterfly
output wire                        Done, // Done Butterfly
input  wire signed [DataWidth-1:0] X_r_in,  X_i_in, // Real and imag. input 
output wire signed [DataWidth-1:0] Y_r_out, Y_i_out// Real and imag. output 
    );

always@(posedge clk) //read Input Data one by one
begin
if (!reset)
  begin
  counter <= 0;
  end
 else
 begin
    X_r_data[counter] <=  X_r_in; //Real Data Input
	 X_i_data[counter] <=  X_i_in; //Imag Data Input
	 counter <= counter +1'b1;
	 end
end

endmodule

module butterfly
//=============================================================================	
//========================= Parameters Declarations ===========================		
//=============================================================================
#(
 // The width of the input, output and twiddle factors.
 parameter DataWidth = 16
 )
//=============================================================================
//========================   Inputs Declarations   ============================
//=============================================================================
(
input  wire                        clk,// System clock
input  wire                        reset,// Asynchronous reset
input  wire                        Start,// Start Butterfly
output wire                        Done, // Done Butterfly
input  wire signed [DataWidth-1:0] XA_r_in,  XA_i_in, // Real and imag. input A
input  wire signed [DataWidth-1:0] XB_r_in,  XB_i_in, // Real and imag. input B
output wire signed [DataWidth-1:0] YA_r_out, YA_i_out,// Real and imag. output A
output wire signed [DataWidth-1:0] YB_r_out, YB_i_out // Real and imag. output B
);
//parameter N = 4; // Number of points
//parameter Num_Stages = 2; //Num_Stages =log2(N); % Number of stages
//=============================================================================
//=========================== Wire Declarations ===============================
//=============================================================================
wire [8:0] N; // Number of points
assign N = 4;
//=============================================================================
wire [8:0] Stages; //log2(N); % Number of stages
assign Stages = 2;
//=============================================================================
//========================= Registers Declarations ============================
//=============================================================================	 
reg Levels;   //Number of Levels (Points) at each stage
// Storage for output of multipliers and Adders and Subtractor
// Wire of longer length for adding or substracting W*XB to XA.
// If we don't create longer wires for them then we can lose the
// high bit.  The contents of these wires are downshifted into a
// normal size for use.
//YA =  XA + XB
//YB = (XA - XB) * W
reg signed  [DataWidth:0]  YA_r, YA_i,  YB_r, YB_i;
reg signed 	[DataWidth-1:0] sin, cos;// The twiddle factor W.
// Real and imag. output A
assign YA_r_out = YA_r [DataWidth:1]; //Ignore LSB due to the overflow of Multilplication and Addition
assign YA_i_out = YA_i [DataWidth:1]; //Ignore LSB due to the overflow of Multilplication and Addition
// Real and imag. output B
assign YB_r_out = YB_r [DataWidth:1];//Ignore LSB due to the overflow of Multilplication and Addition
assign YB_i_out = YB_i [DataWidth:1];//Ignore LSB due to the overflow of Multilplication and Addition
//calculate Twiddle Factor
assign cos = cos_[index];
assign sin = sin[index];
//=============================================================================
//========================== Initializations ==================================
//============================================================================= 	
//initial
//begin
//$readmemh("cos128x16.txt", cos_rom);//Reading Cosine Values to calculate Twiddle Factor
//$readmemh("sin128x16.txt", sin_rom);//Reading Sine Values to calculate Twiddle Factor
//end
//============================================================================= 	

always @ (posedge clk or negedge reset)
begin
if (!reset)
  begin
	  YA_r <= 1'b0; YA_i <= 1'b0; YB_r <= 1'b0; YB_i <= 1'b0;
  end
else
  begin
//YA =  XA + XB
//YB = (XA - XB) * W
	
	
  end
end
		  
		  
