`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineers: Michelle Herrera-Cuen, James Rosas
// Create Date: 04/14/2026 12:21:18 PM
// Module Name: timeout_tb
// Project Name: Final Project
// Description: Waveform that tests timeout functionality
// 
//////////////////////////////////////////////////////////////////////////////////

module timeout_tb();

    wire timeout;
    
    timeout t0(
        .clk(clk),
        .reset(reset),
        .enable(timer_enable),
        .timeout(timeout)
    );
    
endmodule
