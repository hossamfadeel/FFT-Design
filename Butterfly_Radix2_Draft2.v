`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MSIS LAB
// Engineer: Hossam Hassan
// 
// CreateDate: 11:49:02 05/28/2015 
//Design Name: 
// Module Name: Butterfly_Radix2 
// Project Name: 
// TargetDevices: 
// Tool versions: 
//Description: 
//
//Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Butterfly_Radix2
//=============================================================================	
//========================= ParametersDeclarations ===========================		
//=============================================================================
#(
 // The width of the input, output and twiddle factors.
 parameter DataWidth = 16
 )
//=============================================================================
//======================== InputsDeclarations ============================
//============================================================================= 
(
input  wire signed [DataWidth-1 :0] X0_Re,
input  wire signed [DataWidth-1 :0] X0_Im,
input  wire signed [DataWidth-1 :0] X1_Re,
input  wire signed [DataWidth-1 :0] X1_Im,
output wire signed [DataWidth-1 :0] Y0_Re,
output wire signed [DataWidth-1 :0] Y0_Im,
output wire signed [DataWidth-1 :0] Y1_Re,
output wire signed [DataWidth-1 :0] Y1_Im
);
// Double length product
wire signed 	[DataWidth-1:0] sin, cos;
assign sin = 0;
assign cos = 1;
//Addition Operation
wire signed [DataWidth :0] Y0_Re_Add = X0_Re + X1_Re;//xr[i1] <= xr[i1] + xr[i2];
wire signed [DataWidth :0] Y0_Im_Add = X0_Im + X1_Im;//xi[i1] <= xi[i1] + xi[i2];
//Subtraction Operation
wire signed [DataWidth-1 :0] Y0_Re_Sub = X0_Re - X1_Re;//tr = xr[i1] - xr[i2];
wire signed [DataWidth-1 :0] Y0_Im_Sub = X0_Im - X1_Im;//ti = xi[i1] - xi[i2];
//Output the Addition
assign Y0_Re = Y0_Re_Add;
assign Y0_Im = Y0_Im_Add;
//Twiddle_Factor_Cos_Sin = cos(2*pi*(1/N)*(0:N/2-1))-j*sin(2*pi*(1/N)*(0:N/2-1))
//x(n+k+(Levels/2)+1) = (A-B)*Twiddle_Factor_Level(n+1); % DIF
//Cos
wire signed [(DataWidth*2)-1 :0] Cos_Re_Mul = cos * Y0_Re_Sub;//cos_tr = cos * tr;
wire signed [(DataWidth*2)-1 :0] Cos_Im_Mul = cos * Y0_Im_Sub;//cos_ti = cos * ti; 
//Sin
wire signed [(DataWidth*2)-1 :0] Sin_Re_Mul = sin * Y0_Re_Sub;//sin_tr = sin * tr;
wire signed [(DataWidth*2)-1 :0] Sin_Im_Mul = sin * Y0_Im_Sub;//sin_ti = sin * ti;
// We take the MSB
//First Way
//assign Y1_Re [DataWidth-1 :0] = Cos_Re_Mul [(DataWidth*2)-1 :DataWidth] +  Sin_Im_Mul [(DataWidth*2)-1 :DataWidth]; //xr[i2] <= (cos_tr >>> 14) + (sin_ti >>> 14);
//assign Y1_Im [DataWidth-1 :0] = Cos_Im_Mul [(DataWidth*2)-1 :DataWidth] -  Sin_Re_Mul [(DataWidth*2)-1 :DataWidth]; //xi[i2] <= (cos_ti >>> 14) - (sin_tr >>> 14);

//Second Way
//assign Y1_Re = (Cos_Re_Mul >>> (DataWidth-2)) +  (Sin_Im_Mul >>> (DataWidth-2)); //xr[i2] <= (cos_tr >>> 14) + (sin_ti >>> 14);
//assign Y1_Im = (Cos_Im_Mul >>> (DataWidth-2)) -  (Sin_Re_Mul >>> (DataWidth-2)); //xi[i2] <= (cos_ti >>> 14) - (sin_tr >>> 14);
//assign Y1_Re = Cos_Re_Mul [DataWidth-1:0] +  Sin_Im_Mul [DataWidth-1:0]; //xr[i2] <= (cos_tr >>> 14) + (sin_ti >>> 14);
//assign Y1_Im = Cos_Im_Mul [DataWidth-1:0] -  Sin_Re_Mul [DataWidth-1:0]; //xi[i2] <= (cos_ti >>> 14) - (sin_tr >>> 14);

wire    signed  [(DataWidth*2)-1:  0 ]  Y1_Re_Add_Mul = Cos_Re_Mul +  Sin_Im_Mul ; //xr[i2] <= (cos_tr >>> 14) + (sin_ti >>> 14);
wire    signed  [(DataWidth*2)-1:  0 ]  Y1_Im_Add_Mul = Cos_Im_Mul -  Sin_Re_Mul ; //xi[i2] <= (cos_ti >>> 14) - (sin_tr >>> 14);

assign Y1_Re = Y1_Re_Add_Mul [DataWidth - 1:0]; 
assign Y1_Im = Y1_Im_Add_Mul [DataWidth - 1:0];
endmodule

//module complex_mult(
//    input   wire    signed  [ 15 :  0 ] Re_1,
//    input   wire    signed  [ 15 :  0 ] Im_1,
//    input   wire    signed  [ 11 :  0 ] Re_2,
//    input   wire    signed  [ 11 :  0 ] Im_2,
//    output  wire    signed  [ 15 :  0 ] Re_out,
//    output  wire    signed  [ 15 :  0 ] Im_out
//    );
//
//wire    signed  [ 27 :  0 ] w_Re = Re_1 * Re_2 - Im_1 * Im_2 + 16'sd512;
//wire    signed  [ 27 :  0 ] w_Im = Re_1 * Im_2 + Re_2 * Im_1 + 16'sd512;
//
//assign Re_out = w_Re[10+:16];
//assign Im_out = w_Im[10+:16];
//
//endmodule