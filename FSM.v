`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineers: Michelle Herrera-Cuen, James Rosas
// Create Date: 04/14/2026 11:09:32 AM
// Module Name: FSM
// Project Name: Final Project
// Description: Handles game logic using Moore FSM with simple
// state encoding and clean case structure
//
//////////////////////////////////////////////////////////////////////////////////

module FSM(
    input clk,
    input rst,
    
    input start_btn,
    input btn_pressed,
    input correct,
    input timeout,
    input play_done,
    input end_btn,
    input [1:0] rand_note,
    
    output reg [1:0] note_sel,
    output reg [2:0] state
    );
    
    // States
    parameter IDLE = 3'b000;
    parameter START = 3'b001;
    parameter PLAY = 3'b010;
    parameter WAIT_INPUT = 3'b011;
    parameter CHECK = 3'b100;
    parameter SCORE = 3'b101;
    parameter GAME_OVER = 3'b110;
    
    reg [2:0] next_state;
    
    // =====================
    // STATE REGISTER
    // =====================
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
        end
    
    // =====================
    // NEXT STATE LOGIC
    // =====================
    always @(*) begin
        if (end_btn)
            next_state = GAME_OVER;
        else begin
            case(state)
                    IDLE:
                        next_state = (start_btn) ? START : IDLE;
    
                    START:
                        next_state = PLAY;
                    
                    PLAY:
                        next_state = (play_done) ? WAIT_INPUT : PLAY; // wait for more time
                    
                    WAIT_INPUT:
                        if (timeout)
                            next_state = GAME_OVER;
                        else if (btn_pressed)
                            next_state = CHECK;
                        else
                            next_state = WAIT_INPUT;
                    
                    CHECK:
                        next_state = (correct) ? SCORE : GAME_OVER;
                    
                    SCORE:
                        next_state = PLAY;
                    
                    GAME_OVER:
                        next_state = (start_btn) ? IDLE : GAME_OVER;
                    
                    default:
                        next_state = IDLE;
                    
                    endcase
                end
        ]end
    
    // =====================
    // OUTPUT LOGIC (NOTE)
    // =====================
    always @(posedge clk or posedge rst) begin
        if (rst)
            note_sel <= 0;
        else if (state == PLAY)
            note_sel <= rand_note;
    end

endmodule
