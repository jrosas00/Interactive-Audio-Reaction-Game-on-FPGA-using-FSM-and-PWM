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

module ButtonInput(
    input btn[5:0],
    output btn_clean[5:0]);
    
   
