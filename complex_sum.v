`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MSIS LAB
// Engineer: Hossam Hassan
// 
// Create Date:    22:22:49 05/27/2015 
// Design Name: 
// Module Name:    complex_sum 
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
module complex_sum
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
input   wire    signed  [ DataWidth-1 :  0 ] Re_1,
input   wire    signed  [ DataWidth-1  :  0 ] Im_1,
input   wire    signed  [ DataWidth-1  :  0 ] Re_2,
input   wire    signed  [ DataWidth-1  :  0 ] Im_2,
output  wire    signed  [ DataWidth-1  :  0 ] Re_out,
output  wire    signed  [ DataWidth-1  :  0 ] Im_out
);

wire    signed  [ DataWidth :  0 ] w_Re = Re_1 + Re_2;
wire    signed  [ DataWidth :  0 ] w_Im = Im_1 + Im_2;

assign Re_out = w_Re[DataWidth-:DataWidth];
assign Im_out = w_Im[DataWidth-:DataWidth];

endmodule


//module complex_sum(
//    input   wire    signed  [ 15 :  0 ] Re_1,
//    input   wire    signed  [ 15 :  0 ] Im_1,
//    input   wire    signed  [ 15 :  0 ] Re_2,
//    input   wire    signed  [ 15 :  0 ] Im_2,
//    output  wire    signed  [ 15 :  0 ] Re_out,
//    output  wire    signed  [ 15 :  0 ] Im_out
//    );
//
//wire    signed  [ 16 :  0 ] w_Re = Re_1 + Re_2;
//wire    signed  [ 16 :  0 ] w_Im = Im_1 + Im_2;
//
//assign Re_out = w_Re[16-:16];
//assign Im_out = w_Im[16-:16];
//
//endmodule
