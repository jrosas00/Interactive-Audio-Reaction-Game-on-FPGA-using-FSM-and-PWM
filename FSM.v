`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineers: Michelle Herrera-Cuen, James Rosas
// Create Date: 04/14/2026 11:09:32 AM
// Module Name: FSM
// Project Name: Final Project
// Description: Handles game logic using Moore FSM with simple
//              state encoding and clean case structure
// 
//////////////////////////////////////////////////////////////////////////////////

module FSM(
    input clk,
    input reset,
    input start_btn,
    input btn_pressed,
    input correct,
    input timeout,

    output reg [2:0] state
);

    // State encoding (game phases)
    parameter IDLE       = 3'b000; // Waiting for player to press start
    parameter START      = 3'b001; // One-cycle setup before playing note
    parameter PLAY       = 3'b010; // Play note (sound ON, timer running)
    parameter PAUSE      = 3'b011; // One-cycle gap to reset timer
    parameter WAIT_INPUT = 3'b100; // Wait for player input (sound OFF)
    parameter CHECK      = 3'b101; // Evaluate answer
    parameter SCORE      = 3'b110; // Correct answer, increment score
    parameter GAME_OVER  = 3'b111; // Wrong/timeout, wait for restart
    
    reg [2:0] next_state;
    
    // State register: updates current state on clock edge
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case(state)
            // Wait for start button
            IDLE: begin
                if (start_btn)
                    next_state = START;
                else
                    next_state = IDLE;
            end
    
            // One-cycle transition to begin playing note
            START: begin
                next_state = PLAY; 
            end
    
            // Play note until timeout expires
            PLAY: begin
                 if (timeout)
                     next_state = PAUSE;
                 else
                     next_state = PLAY;
            end
            
            // One-cycle state to reset timer before input phase
            PAUSE: begin 
                next_state = WAIT_INPUT; 
            end
    
            // Wait for player response or timeout
            WAIT_INPUT: begin
                if (timeout)
                    next_state = GAME_OVER;
                else if (btn_pressed)
                    next_state = CHECK;
                else
                    next_state = WAIT_INPUT;
            end
    
            // Determine if answer is correct
            CHECK: begin
                if (correct)
                    next_state = SCORE;
                else
                    next_state = GAME_OVER;
            end
    
            // Correct answer, move to next round
            SCORE: begin
                next_state = PLAY;
            end
    
            // Stay here until player presses start to restart
            GAME_OVER: begin
                if (start_btn)
                    next_state = START;
                else
                    next_state = GAME_OVER;
            end
    
            default: next_state = IDLE;
    
        endcase
    end

endmodule
