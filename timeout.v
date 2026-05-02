`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineers: Michelle Herrera-Cuen, James Rosas
// Create Date: 04/14/2026 12:07:59 PM
// Module Name: timeout
// Project Name: Final Project
// Description: Handles timout for WAIT_INPUT, PLAY state in FSM
// 
//////////////////////////////////////////////////////////////////////////////////

module timeout(
    input clk,
    input reset,
    input enable,
    output reg timeout
    );
    
    reg [31:0] count;
    parameter LIMIT = 100_000_000; // ~1 sec using 100MHz clock
    
    always @(posedge clk or posedge reset) begin
       if (reset) begin
           count <= 0;
           timeout <= 0;
       end
       else if (enable) begin
           if (count >= LIMIT) begin
               timeout <= 1;
               count <= 0;
           end
           else begin
               count <= count + 1;
               timeout <= 0;
           end
       end
       else begin
           count <= 0;
           timeout <= 0;
       end
    end
    
endmodule
