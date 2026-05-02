`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: James Rosas, Michelle Herrera-Cuen
// 
// Create Date: 04/21/2026 07:53:07 PM
// Design Name: 
// Module Name: Top
// Project Name: Final Project
// Description: FPGA rhythm audio reaction game using 6 external push buttons and pwm output to speaker
//  Top initializes all modules, encodes button presses, assigns notes played to pwm, 
//  and checks whether button pressed matches note played
//////////////////////////////////////////////////////////////////////////////////



module Top(
    input clk,
    input [5:0] button,
    output speaker,
    output [7:0] cathode,
    output [7:0] anode
    );
    
    wire [5:0] btn_press;            // Output of button debouncer
    wire note_button_pressed;        // Used to detect if note buttons are pressed
    reg [1:0] selected_note;         // Note button that player selects
    wire reset_pulse = btn_press[0]; // Debounced pulse from reset button
    wire start_pulse = btn_press[1]; // Debounced pulse from start button
        
    wire [7:0] lfsr;
    wire [1:0] note_sel; // Note that LFSR selects
    
    reg [21:0] pwm_period;
    reg [21:0] pwm_duty;
    wire pwm_out;
    
    reg correct; // Used to hold if button pressed matches note played
    reg wrong;   // Used to detect if button does not match note played
    wire game_reset;
    wire game_advance;
    assign game_advance = start_pulse | correct; // Combines start button with correct note button press
    assign game_reset = reset_pulse | wrong;     // Resets score on reset button or wrong answer
    
    wire w_Hz_Gen;
    wire [3:0] w_ones,w_tens;
    
    wire [2:0] state;
    // State encoding used to interpret FSM output in Top
    parameter IDLE       = 3'b000;
    parameter START      = 3'b001;
    parameter PLAY       = 3'b010;
    parameter PAUSE      = 3'b011;
    parameter WAIT_INPUT = 3'b100;
    parameter CHECK      = 3'b101;
    parameter SCORE      = 3'b110;
    parameter GAME_OVER  = 3'b111;
    
    wire timeout_signal;
    wire timeout_enable;
    assign timeout_enable = (state == PLAY) || (state == WAIT_INPUT);
    
    // instantiate button module
    ButtonInput b0(
        .clk(clk),
        .btn(button),
        .btn_press(btn_press)
    );
    
    LFSR lfsr_inst(
        .clk(clk),
        .reset(reset_pulse),
        .enable(game_advance), // Advance to a new random note on start or correct answer
        .lfsr(lfsr),
        .note_sel(note_sel)   
    );
    
    PWM pwm_inst (
        .clk(clk),
        .reset(reset_pulse),
        .pwm_period(pwm_period),
        .pwm_duty(pwm_duty),
        .pwm_out(pwm_out)
    );
    
    // instantiate the secondary clock used by the 7 segment display
    Hz_Gen Hz500(.clk(clk), .reset(reset_pulse), .clk_7_segment(w_Hz_Gen));
    
    // Score counter: increments on correct answer and resets on wrong/reset
    Digit_Incrementer digits(.clk(clk), .reset(game_reset), 
    .increment_digit(correct), .ones(w_ones), .tens(w_tens)); 
    
    // Drives the two-digit seven-segment display using the divided clock
    Seven_Segment_Display segment_control(.clk_7_segment(w_Hz_Gen), .reset(reset_pulse), 
    .ones(w_ones), .tens(w_tens), .cathode(cathode), .anode(anode));
    
    // Finite state machine controlling game flow
    FSM fsm_inst(
        .clk(clk),
        .reset(reset_pulse),
        .start_btn(start_pulse),
        .btn_pressed(note_button_pressed),
        .correct(correct),
        .timeout(timeout_signal),
        .state(state)
    );
    
    timeout timeout_inst(
        .clk(clk),
        .reset(reset_pulse),
        .enable(timeout_enable),
        .timeout(timeout_signal)    
    );
    
    // High when any of the four note-selection buttons is pressed
    assign note_button_pressed = btn_press[2] | btn_press[3] | btn_press[4] | btn_press[5];
    
    // Encode which note button was pressed
    always @(*) begin
        if(btn_press[2])
            selected_note = 2'd0;
        else if(btn_press[3])
            selected_note = 2'd1;
        else if(btn_press[4])
            selected_note = 2'd2;
        else if(btn_press[5])
            selected_note = 2'd3;
        else
            selected_note = 2'd0; // Default case when no button is pressed. 
     end      
     
     // maps note_sel to pwm_period and pwm_duty
     always @(*) begin
        case(note_sel)
            2'd0: pwm_period = 22'd382219; // C4
            2'd1: pwm_period = 22'd340529; // D4
            2'd2: pwm_period = 22'd303371; // E4
            2'd3: pwm_period = 22'd286345; // F4
            default: pwm_period = 22'd382219; // C4
        endcase
        pwm_duty = pwm_period >> 1; // 50% duty cycle
     end
     
     assign speaker = (state == PLAY) ? pwm_out : 1'b0; // Speaker active only during PLAY state
     
     // Generate one-clock pulses for correct or wrong answer events
     always @(posedge clk or posedge reset_pulse) begin
        if(reset_pulse) begin
            correct <= 1'b0;
            wrong   <= 1'b0;
        end
        else begin
            correct <= 1'b0;
            wrong   <= 1'b0;
            if((state == WAIT_INPUT) && note_button_pressed) begin
                if(note_sel == selected_note)
                    correct <= 1'b1;
                else
                    wrong   <= 1'b1;        
            end
        end    
     end             

endmodule
