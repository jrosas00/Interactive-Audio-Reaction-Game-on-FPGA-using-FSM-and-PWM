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
// Description: 
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
    input button_inc, // Probably need to increase bit size to handle multiple different buttons? Depending on fsm logic
    output reg [3:0] ones,
    output reg [3:0] tens
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ones <= 4'd0;
            tens <= 4'd0;
        end
        else if (button_inc) begin // Whenever a button is pressed increments ones or tens
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
