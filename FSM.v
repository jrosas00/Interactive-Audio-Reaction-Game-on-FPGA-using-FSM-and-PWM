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
    input rst,

    input start_btn,
    input btn_pressed,
    input correct,
    input timeout,

    output reg [2:0] state
);

    // State encoding
    parameter IDLE       = 3'b000;
    parameter START      = 3'b001;
    parameter PLAY       = 3'b010;
    parameter WAIT_INPUT = 3'b011;
    parameter CHECK      = 3'b100;
    parameter SCORE      = 3'b101;
    parameter GAME_OVER  = 3'b110;
    
    reg [2:0] next_state;
    
    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    // Next state logic
    always @(*) begin
        case(state)
    
            IDLE: begin
                if (start_btn)
                    next_state = START;
                else
                    next_state = IDLE;
            end
    
            START: begin
                next_state = PLAY; // !!! FOR NOW !!
            end
    
            PLAY: begin
                next_state = WAIT_INPUT;
            end
    
            WAIT_INPUT: begin
                if (timeout)
                    next_state = GAME_OVER;
                else if (btn_pressed)
                    next_state = CHECK;
                else
                    next_state = WAIT_INPUT;
            end
    
            CHECK: begin
                if (correct)
                    next_state = SCORE;
                else
                    next_state = GAME_OVER;
            end
    
            SCORE: begin
                next_state = PLAY;
            end
    
            GAME_OVER: begin
                if (start_btn)
                    next_state = IDLE;
                else
                    next_state = GAME_OVER;
            end
    
            default: next_state = IDLE;
    
        endcase
    end

endmodule