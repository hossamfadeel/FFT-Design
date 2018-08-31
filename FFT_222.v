`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MSIS LAB
// Engineer: Hossam Hassan 
// 
// Create Date:    16:01:09 05/21/2015 
// Design Name: 
// Module Name:    FFT_222 
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
module FFT_222(
    );

module sequential_adder(a, b, sum, clock); 
parameter width = 1; 
input  [width-1:0] a; 
input  [width-1:0] b; 
input  clock; 
output [width-1:0] sum; 
reg    [width-1:0] sum; 
 
always @(posedge clk) 
  sum = a + b; 
 
endmodule 
 
 
module sequential_subtractor(a, b, difference, clock); 
parameter width = 1; 
input  [width-1:0] a; 
input  [width-1:0] b; 
input  clock; 
output [width-1:0] difference; 
reg    [width-1:0] difference; 
 
always @(posedge clk) 
  difference = a - b; 
 
endmodule 
 
 
module real_butterfly(in0, in1, out0, out1, clock); 
parameter width = 1; 
input  [width-1:0] in0; 
input  [width-1:0] in1; 
input  clock; 
output [width-1:0] out0; 
output [width-1:0] out1; 
reg    [width-1:0] out0; 
reg    [width-1:0] out1; 
 
sequential_adder      #(width) positive (in0, in1, out0, clock); 
sequential_subtractor #(width) negative (in0, in1, out1, clock); 
 
endmodule 
 
 
module complex_butterfly(re_in0, im_in0, re_in1, im_in1, re_out0, im_out0, re_out1, im_out1, clock); 
parameter width = 1; 
input  [width-1:0] re_in0; 
input  [width-1:0] im_in0; 
input  [width-1:0] re_in1; 
input  [width-1:0] im_in1; 
input  clock; 
output [width-1:0] re_out0; 
output [width-1:0] im_out0; 
output [width-1:0] re_out1; 
output [width-1:0] im_out1; 
reg    [width-1:0] re_out0; 
reg    [width-1:0] im_out0; 
reg    [width-1:0] re_out1; 
reg    [width-1:0] im_out1; 
 
real_butterfly #(width) re_part (re_in0, re_in1, re_out0, re_out1, clock); 
imag_butterfly #(width) im_part (im_in0, im_in1, im_out0, im_out1, clock); 
 
endmodule 
 
 
module multiplexor(in0, in1, select, out, clock); 
parameter width = 1; 
input  [width-1:0] in0; 
input  [width-1:0] in1; 
input  select; 
input  clock; 
output [width-1:0] out; 
reg    [width-1:0] out; 
 
always @(posedge clock) 
  if(select) 
    out = in1; 
  else 
    out = in0; 
 
endmodule 
 
//module multiplexor(in, select, out); 
//parameter width = 1, select_bits = 1; 
//input  [width-1:0][(1<<select_bits)-1:0] in; 
//input  [select_bits-1:0] select; 
//output [width-1:0] out; 
//reg    [width-1:0] out; 
// 
//always@(posedge clk) 
//  out = in[select]; 
//endmodule 
 
module delay(in, length, out, clock); 
parameter width = 1; 
input  [width-1:0] in; 
input  clock; 
output [width-1:0] out; 
reg    [width-1:0] out; 
 
 
endmodule
