`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineers: Michelle Herrera-Cuen, James Rosas
// Create Date: 03/26/2026 11:58:28 AM
// Project Name: Final Project
// Description: Connect FPGA to buttons, Test Hz, Test Digit Increment
//              test seven segment display
// 
//////////////////////////////////////////////////////////////////////////////////

module Top(
    input clk,
    input reset,
    input [5:0] btn,
    output [7:0] cathode,
    output [5:0] led,
    output [7:0] anode
    );
    
   wire [5:0] btn_press;
   wire w_Hz_Gen;
   wire [3:0] w_ones,w_tens;
   
   wire [2:0] state;
   
   // temporary test signals
   wire start_btn;
   wire btn_pressed;
   wire correct;
   wire timeout;
   
   // map buttons
   assign start_btn  = btn_press[0]; // start button
   assign btn_pressed = btn_press[1]; // simulate press
   assign correct     = btn_press[2]; // simulate correct
   assign timeout     = btn_press[3]; // simulate timeout
   // show FSM state on display
   assign w_ones = {1'b0, state};  // pad to 4 bits
   assign w_tens = 4'b0000;
   
   // instantiate FSM
   FSM fsm0(
       .clk(clk),
       .rst(reset),
       .start_btn(start_btn),
       .btn_pressed(btn_pressed),
       .correct(correct),
       .timeout(timeout),
       .state(state)
   );
   
    // instantiate button module
    ButtonInput b0(
        .clk(clk),
        .btn(btn),
        .btn_press(btn_press)
    );
    
    // instantiate the secondary clock used by the 7 segment display
   // clock divider
   Hz_Gen Hz500(.clk(clk), .reset(reset), .clk_7_segment(w_Hz_Gen));
   
   /*
   // instantiate the module that increments digit value from buttons
   Digit_Incrementer digits(.clk(clk), .reset(reset), 
   .button_inc(btn_press[1]), .ones(w_ones), .tens(w_tens)); // Currently only works with one button at a time, can fix in Digit_Selector
   */
   
   // instantiate the module that controls 7 segment display behavior using slowed down clock
   Seven_Segment_Display segment_control(.clk_7_segment(w_Hz_Gen), .reset(reset), 
   .ones(w_ones), .tens(w_tens), .cathode(cathode), .anode(anode));

endmodule
