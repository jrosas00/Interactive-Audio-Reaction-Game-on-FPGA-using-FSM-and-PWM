`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: James Rosas, Michelle Herrera-Cuen
// 
// Create Date: 04/11/2026 10:23:42 PM
// Design Name: 
// Module Name: Digit_Incrementer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Responsible for incrementing ones or tens digit for 7 segment display
//              Send increment_digit signal to increment digit by 1
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Digit_Incrementer(
    input clk,
    input reset,
    input increment_digit, // Send a single signal to increment
    output reg [3:0] ones,
    output reg [3:0] tens
    );
       
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
        end
        else if (increment_digit) begin 
            if (ones == 4'd9) begin
                ones <= 4'd0;
                if (tens == 4'd9)
                    tens <= 4'd0;
                else
                    tens <= tens + 4'd1;
            end
            else begin
                ones <= ones + 4'd1;
            end
        end
    end
    
endmodule
