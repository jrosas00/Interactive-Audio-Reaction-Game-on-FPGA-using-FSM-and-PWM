`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: James Rosas, Michelle Herrera-Cuen
// 
// Create Date: 04/25/2026 10:01:31 PM
// Design Name: 
// Module Name: LFSR
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
// 8-bit Linear Feedback Shift Register (LFSR) used to generate pseudo-random
// values for note selection in the game.
//
// - Advances only when 'enable' is high
// - Uses a maximal-length polynomial: x^8 + x^6 + x^5 + x^4 + 1
// - Outputs a 2-bit value (note_sel) to select 1 of 4 notes
//
// - LFSR must never be initialized to 0 (locks state)



module LFSR(
    input clk,
    input reset,
    input enable,           // Advance LFSR when high
    output reg [7:0] lfsr,  // Current LFSR state, can remove this output later?
    output [1:0] note_sel   // 2-bit value used to select one of 4 notes
    );
    
    always @(posedge clk or posedge reset) begin
        if(reset)
            // Change seed to change order in which notes are played
            lfsr <= 8'b00000001; // Nonzero seed (required for LFSR operation)
        else if(enable)
            // Feedback taps: bits [7], [5], [4], [3]
            // New bit = XOR of selected taps
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
    end
    
    // Use the 2 least significant bits to select one of 4 notes
    assign note_sel = lfsr[1:0];
        
endmodule
