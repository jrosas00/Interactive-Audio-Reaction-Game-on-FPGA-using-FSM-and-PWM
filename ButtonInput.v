`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineers: Michelle Herrera-Cuen, James Rosas
// Create Date: 03/26/2026 12:00:39 PM
// Design Name: Final Project
// Description: Handles Button Presses
//
//////////////////////////////////////////////////////////////////////////////////

/*
    PSUEDOCODE:
    input: clk, btn[5:0]
    output: btn_clean[5:0]

    for each buttotn:
        synchronize button to clock
        check dbeounce(implement later)
        output clean signal

*/

module ButtonInput (
    input clk,
    input  [5:0] btn,
    output [5:0] btn_press // Declared as a wire. Output without reg is wire
);

    wire[5:0] btn_release; //add to module ButtonInput port list if used in TOP
    
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
   
