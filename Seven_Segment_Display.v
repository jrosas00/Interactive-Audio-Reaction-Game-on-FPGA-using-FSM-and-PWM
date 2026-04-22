`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: James Rosas, Michelle Herrera-Cuen
// 
// Create Date: 04/11/2026 08:29:26 PM
// Design Name: 
// Module Name: Seven_Segment_Display
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

module Seven_Segment_Display(
    input clk_7_segment,
    input reset,
    input [3:0] ones,
    input [3:0] tens,
    output reg [7:0] cathode, // Segment pattern 0-9
    output reg [7:0] anode    // Selects anodes/which 7 segment display is on
);

    // Parameters for 7 segment display patterns
    parameter ZERO    = 8'b00000011; //0
    parameter ONE     = 8'b10011111; //1
    parameter TWO     = 8'b00100101; //2
    parameter THREE   = 8'b00001101; //3
    parameter FOUR    = 8'b10011001; //4
    parameter FIVE    = 8'b01001001; //5
    parameter SIX     = 8'b01000001; //6
    parameter SEVEN   = 8'b00011111; //7
    parameter EIGHT   = 8'b00000001; //8
    parameter NINE    = 8'b00001001; //9
    parameter DECIMAL = 8'b11111110; //Decimal point
    
    reg digit_select = 0; // 0 = ones, 1 = tens
    reg [3:0] current_digit;
    
    // Toggle between digits using slowed clock
    // Currently toggles at 500Hz
    always @(posedge clk_7_segment or posedge reset) begin
        if (reset)
            digit_select <= 0;
        else
            digit_select <= ~digit_select;
    end
    
     // Combinational logic
    always @(*) begin
        // defaults
        cathode = 8'b11111111;
        anode   = 8'b11111111;
        current_digit = 4'd0;

        case (digit_select)
            1'b0: begin
                anode = 8'b11111110; // ones ON
                current_digit = ones;
            end
            1'b1: begin
                anode = 8'b11111101; // tens ON
                current_digit = tens;
            end
        endcase

        case (current_digit)
            4'd0: cathode = ZERO;
            4'd1: cathode = ONE;
            4'd2: cathode = TWO;
            4'd3: cathode = THREE;
            4'd4: cathode = FOUR;
            4'd5: cathode = FIVE;
            4'd6: cathode = SIX;
            4'd7: cathode = SEVEN;
            4'd8: cathode = EIGHT;
            4'd9: cathode = NINE;
            default: cathode = 8'b11111111;
        endcase
    end
endmodule
