`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineers: Michelle Herrera-Cuen, James Rosas
// Create Date: 03/26/2026 12:00:39 PM
// Design Name: Final Project
// Description: Handles Button Presses by calling Button_Debouncer with # of buttons required
//
//////////////////////////////////////////////////////////////////////////////////


module ButtonInput (
    input clk,
    input  [5:0] btn,
    output [5:0] btn_press 
);

    wire[5:0] btn_release; 
    
    Button_Debouncer b0(
        .clk(clk),
        .BUTTON(btn[0]),
        .RISING_EDGE_PULSE(btn_press[0]),
        .FALLING_EDGE_PULSE(btn_release[0])
    );
    
     Button_Debouncer b1(
        .clk(clk),
        .BUTTON(btn[1]),
        .RISING_EDGE_PULSE(btn_press[1]),
        .FALLING_EDGE_PULSE(btn_release[1])
    );
     Button_Debouncer b2(
        .clk(clk),
        .BUTTON(btn[2]),
        .RISING_EDGE_PULSE(btn_press[2]),
        .FALLING_EDGE_PULSE(btn_release[2])
    );
     Button_Debouncer b3(
        .clk(clk),
        .BUTTON(btn[3]),
        .RISING_EDGE_PULSE(btn_press[3]),
        .FALLING_EDGE_PULSE(btn_release[3])
    );
     Button_Debouncer b4(
        .clk(clk),
        .BUTTON(btn[4]),
        .RISING_EDGE_PULSE(btn_press[4]),
        .FALLING_EDGE_PULSE(btn_release[4])
    );
     Button_Debouncer b5(
        .clk(clk),
        .BUTTON(btn[5]),
        .RISING_EDGE_PULSE(btn_press[5]),
        .FALLING_EDGE_PULSE(btn_release[5])
    );

   
endmodule
   
