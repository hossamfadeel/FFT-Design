`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: MSIS LAB
// Engineer: Hossam Hassan
// 
// Create Date:    14:50:27 05/27/2015 
// Design Name: 
// Module Name:    FFT_Trials 
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
module FFT_Trials(
    );


endmodule
module butterfly_test_2
  #(
    // The width of m_in.
    parameter M_WDTH = 0,
    // The width of the input, output and twiddle factors.
    parameter X_WDTH = 0
    )
   (
    input wire                        clk,
    input wire                        rst_n,
    // m_in contains data that passes through this block with no change.
    // It is delayed for 3 counts like x_nd->y_nd.
    input wire [M_WDTH-1:0]           m_in,
    // The twiddle factor.
    input wire signed [2*X_WDTH-1:0]  w,
    // XA
    input wire signed [2*X_WDTH-1:0]  xa,
    // XB
    input wire signed [2*X_WDTH-1:0]  xb,
    // Set to 1 when new data is present on inputs.
    // Cannot be set to 1 for two consecutive steps.
    input wire                        x_nd,
    // delayed version of m_in.
    output reg [M_WDTH-1:0]           m_out,
    // YA = XA + W*XB
    // YB = XA - W*XB
    // When y_nd=1 y_re and y_im are outputing YA.
    // The step after they are outputting YB.
    output wire signed [2*X_WDTH-1:0] y,
    output reg                        y_nd
    );

   // Set wire to the real and imag parts for convenience.
   wire signed [X_WDTH-1:0]        w_re;
   wire signed [X_WDTH-1:0]        w_im;
   assign w_re = w[2*X_WDTH-1:X_WDTH];
   assign w_im = w[X_WDTH-1:0];
   wire signed [X_WDTH-1:0]        xa_re;
   wire signed [X_WDTH-1:0]        xa_im;
   assign xa_re = xa[2*X_WDTH-1:X_WDTH];
   assign xa_im = xa[X_WDTH-1:0];
   wire signed [X_WDTH-1:0]        xb_re;
   wire signed [X_WDTH-1:0]        xb_im;
   assign xb_re = xb[2*X_WDTH-1:X_WDTH];
   assign xb_im = xb[X_WDTH-1:0];
   reg signed [X_WDTH-1: 0]        y_re;
   reg signed [X_WDTH-1: 0]        y_im;
   assign y = {y_re, y_im};
   
   // Delayed m_in.
   reg signed [M_WDTH-1:0]         m[1:0];
   // Delayed XA
   reg signed [X_WDTH-1:0]         za_re[1:0];
   reg signed [X_WDTH-1:0]         za_im[1:0];
   // Delayed XB
   reg signed [X_WDTH-1:0]         zb_re;
   reg signed [X_WDTH-1:0]         zb_im;
   // Delayed W
   reg signed [X_WDTH-1:0]         ww_re;
   reg signed [X_WDTH-1:0]         ww_im;
   // Delayed x_nd
   reg signed                      x_nd_old[2:0];
   // Storage for output of multipliers
   reg signed [2*X_WDTH-1:0]         zbw_m1;
   reg signed [2*X_WDTH-1:0]         zbw_m2;
   // W * XB
   reg signed [X_WDTH-1:0]         zbw_re;
   wire signed [X_WDTH-1:0]        zbw_im;
   assign zbw_im = (zbw_m1 >>> (X_WDTH-2)) + (zbw_m2 >>> (X_WDTH-2));
   reg signed [X_WDTH-1:0]         zbw_im_old;
   // Wire of longer length for adding or substracting W*XB to XA.
   // If we don't create longer wires for them then we can lose the
   // high bit.  The contents of these wires are downshifted into a
   // normal size for use.
   wire signed [X_WDTH:0]            z1_re_big;
   wire signed [X_WDTH:0]            z1_im_big;
   assign z1_re_big = za_re[0] + zbw_re;
   assign z1_im_big = za_im[0] + zbw_im;
   wire signed [X_WDTH:0]            z2_re_big;
   wire signed [X_WDTH:0]            z2_im_big;
   assign z2_re_big = za_re[1] - zbw_re;
   assign z2_im_big = za_im[1] - zbw_im_old;
   
  always @ (posedge clk or negedge rst_n)
    begin
      if (!rst_n)
        begin
           y_nd <= 1'b0;
        end
      else
        begin
           // Set delay for x_nd_old and m.
           x_nd_old[0] <= x_nd;
           x_nd_old[1] <= x_nd_old[0];
           x_nd_old[2] <= x_nd_old[1];
           m[0] <= m_in;
           m[1] <= m[0];
           m_out <= m[1];
           // STAGE 1
           if (x_nd)
             begin
                za_re[0] <= xa_re;
                za_im[0] <= xa_im;
                ww_re <= w_re;
                ww_im <= w_im;
                zb_re <= xb_re;
                zb_im <= xb_im;
                // We perform two multiplications for calculate the real part
                // of W*XB.
                zbw_m1 <= xb_re*w_re;
                zbw_m2 <= xb_im*w_im;
                if (x_nd_old[0])
                  $display("ERROR: BF got new data two steps in a row.");
             end
           if (x_nd_old[0])
           // STAGE 2
             begin
                // Now start the multiplications for the imag part of W*WB.
                zbw_m1 <= zb_re*ww_im;
                zbw_m2 <= zb_im*ww_re;
                // Downshift the multiplied results into normal width and
                // substract them.
                // Overflow is not possible upon substraction since we
                // know that W and XB both have magnitude less than 1
                // so their multiple must also.
                zbw_re <= (zbw_m1 >>> (X_WDTH-2)) - (zbw_m2 >>> (X_WDTH-2));
             end
           // STAGE 3
           if (x_nd_old[1])
             begin
                // We only need to shift the required delayed data
                // with XA every two steps since new input cannot
                // arrive more frequently than that.
                // XA is needed by a wire calculating z2_re_big and ze_im_big
                // next step.
                za_re[1] <= za_re[0];
                za_im[1] <= za_im[0];
                // Output YA.
                y_nd <= 1'b1;
                y_re <= z1_re_big >>> 1;
                y_im <= z1_im_big >>> 1;
                zbw_im_old <= zbw_im;
             end
           // STAGE 4
           if (x_nd_old[2])
             begin
                // Output YB.
                y_nd <= 1'b0;
                y_re <= z2_re_big >>> 1;
                y_im <= z2_im_big >>> 1;
             end
        end
    end

endmodule


module butterfly_test
  #(
    parameter WIDTH = 32,
    parameter MWIDTH = 1
    )
   (
    input wire                     clk,
    input wire                     rst_n,
    // m_in contains data that passes through this block with no change.
    input wire [MWIDTH-1:0]        m_in,
    // The twiddle factor.
    input wire signed [WIDTH-1:0]  w,
    // XA
    input wire signed [WIDTH-1:0]  xa,
    // XB
    input wire signed [WIDTH-1:0]  xb,
    // Set to 1 when new data is present on inputs.
    input wire                     x_nd,
    // delayed version of m_in.
    output reg [MWIDTH-1:0]        m_out,
    // YA = XA + W*XB
    // YB = XA - W*XB
    output wire signed [WIDTH-1:0] ya,
    output wire signed [WIDTH-1:0] yb,
    output reg                     y_nd,
    output reg                     error
    );

   // Set wire to the real and imag parts for convenience.
   wire signed [WIDTH/2-1:0]        xa_re;
   wire signed [WIDTH/2-1:0]        xa_im;
   assign xa_re = xa[WIDTH-1:WIDTH/2];
   assign xa_im = xa[WIDTH/2-1:0];
   wire signed [WIDTH/2-1: 0]       ya_re;
   wire signed [WIDTH/2-1: 0]       ya_im;
   assign ya = {ya_re, ya_im};
   wire signed [WIDTH/2-1: 0]       yb_re;
   wire signed [WIDTH/2-1: 0]       yb_im;
   assign yb = {yb_re, yb_im};

   // Delayed stuff.
   reg signed [WIDTH/2-1:0]         xa_re_z;
   reg signed [WIDTH/2-1:0]         xa_im_z;
   // Output of multiplier
   wire signed [WIDTH-1:0]          xbw;
   wire signed [WIDTH/2-1:0]        xbw_re;
   wire signed [WIDTH/2-1:0]        xbw_im;
   assign xbw_re = xbw[WIDTH-1:WIDTH/2];
   assign xbw_im = xbw[WIDTH/2-1:0];
   // Do summing
   // I don't think we should get overflow here because of the
   // size of the twiddle factors.
   // If we do testing should catch it.
   assign ya_re = xa_re_z + xbw_re;
   assign ya_im = xa_im_z + xbw_im;
   assign yb_re = xa_re_z - xbw_re;
   assign yb_im = xa_im_z - xbw_im;
   
   // Create the multiply module.
   multiply_complex #(WIDTH) multiply_complex_0
     (.clk(clk),
      .rst_n(rst_n),
      .x(xb),
      .y(w),
      .z(xbw)
      );

  always @ (posedge clk)
    begin
       if (!rst_n)
         begin
            y_nd <= 1'b0;
            error <= 1'b0;
         end
       else
         begin
            // Set delay for x_nd_old and m.
            y_nd <= x_nd;
            m_out <= m_in;
            if (x_nd)
              begin
                 xa_re_z <= xa_re/2;
                 xa_im_z <= xa_im/2;
              end
         end
    end
   
endmodule
