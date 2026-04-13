`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: James Rosas, Michelle Herrera-Cuen
// 
// Create Date: 04/11/2026 08:32:41 PM
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input clk,
    input reset,
    input [5:0] btn,
    output [7:0] cathode,
    output [7:0] anode
    );
    
   wire [5:0] btn_press;
   wire w_Hz_Gen;
   wire [3:0] w_ones,w_tens;
   
    // instantiate button module
    ButtonInput b0(
        .clk(clk),
        .btn(btn),
        .btn_press(btn_press)
    );
    
    // instantiate the secondary clock used by the 7 segment display
   Hz_Gen Hz500(.clk(clk), .reset(reset), .clk_7_segment(w_Hz_Gen));
   
   // instantiate the module that increments digit value from buttons
   Digit_Incrementer digits(.clk(clk), .reset(reset), 
   .button_inc(btn_press[1]), .ones(w_ones), .tens(w_tens)); // Currently only works with one button at a time, can fix in Digit_Selector
   
   // instantiate the module that controls 7 segment display behavior using slowed down clock
   Seven_Segment_Display segment_control(.clk_7_segment(w_Hz_Gen), .reset(reset), 
   .ones(w_ones), .tens(w_tens), .cathode(cathode), .anode(anode));
endmodule
