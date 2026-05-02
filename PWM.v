`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: James Rosas, Michelle Herrera-Cuen
// 
// Create Date: 04/21/2026 04:53:18 PM
// Design Name: 
// Module Name: PWM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Creates a PWM signal based off pwm_period and pwm_duty. These are sent as inputs to this file
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
// Example of what to use in Top.v to test pwm and hear a note
// assign pwm_period = 22'd227273;  // A4 = 440 Hz, Period = 100MHz / 440Hz = 227,273 round as this is an integer
// assign pwm_duty = pwm_period >> 1; This assigns pwm_duty cycle to 50% no matter the pwm_period. Right shift bit by 1 is like dividing by 2

module PWM(
    input clk, // Input is 100MHz clk from FPGA
    input reset,
    input  [21:0] pwm_period, // Max pwm_period (22-bit) = 4,194,303  min frequency = 23.8 Hz, max usable freq is 50MHz
    input  [21:0] pwm_duty,  // Should be set to 50% of period for regular tones
    output pwm_out 
    );
    
    reg [21:0] counter; // Used to count clk cycles from main 100MHz to desired PWM period
    
    always @ (posedge clk or posedge reset)
    begin
        if(reset)
            counter <= 0;
        else if(counter < pwm_period - 1) // Counts from 0 to pwm_period - 1
            counter <= counter + 1;       // Adds 1 to counter each clk from FPGA
        else
            counter <= 0;                 // Once counter reaches pwm_period threshold then counter is set to 0 again
    end
    
    assign pwm_out = (counter < pwm_duty); // If counter is less than pwm_duty then 1/HIGH is output

endmodule
