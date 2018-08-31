`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MSIS LAB
// Engineer: Hossam Hassan
// 
// Create Date:    22:25:27 05/27/2015 
// Design Name: 
// Module Name:    complex_mult 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module complex_mult//=============================================================================	
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
    input   wire    signed  [ 15 :  0 ] Re_1,
    input   wire    signed  [ 15 :  0 ] Im_1,
    input   wire    signed  [ 11 :  0 ] Re_2,
    input   wire    signed  [ 11 :  0 ] Im_2,
    output  wire    signed  [ 15 :  0 ] Re_out,
    output  wire    signed  [ 15 :  0 ] Im_out
    );

wire    signed  [ 27 :  0 ] w_Re = Re_1 * Re_2 - Im_1 * Im_2 + 16'sd512;
wire    signed  [ 27 :  0 ] w_Im = Re_1 * Im_2 + Re_2 * Im_1 + 16'sd512;

assign Re_out = w_Re[10+:16];
assign Im_out = w_Im[10+:16];

endmodule
