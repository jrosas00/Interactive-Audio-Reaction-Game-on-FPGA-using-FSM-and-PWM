`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: James Rosas, Michelle Herrera-Cuen
// 
// Create Date: 04/21/2026 07:53:07 PM
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Top module to test LFSR random note generator that sends note to PWM.v
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module Top(
    input clk,
    input reset,
    output speaker
    );

    reg  [21:0] pwm_period;
    reg  [21:0] pwm_duty;
    wire pwm_out;

    wire [7:0] lfsr;
    wire [1:0] note_sel;

    // 1-second note change timer
    reg [26:0] note_counter;
    reg lfsr_enable;
    localparam NOTE_TIME = 27'd100000000; // 1 second at 100 MHz


    PWM pwm_inst (
        .clk(clk),
        .reset(reset),
        .pwm_period(pwm_period),
        .pwm_duty(pwm_duty),
        .pwm_out(pwm_out)
    );
    
    LFSR lfsr_inst (
        .clk(clk),
        .reset(reset),
        .enable(lfsr_enable),
        .lfsr(lfsr),
        .note_sel(note_sel)   
    );

  // Counter generates a 1-clock pulse to advance the LFSR once every second
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            note_counter <= 0;
            lfsr_enable <= 1'b0;
        end
        else begin
            if (note_counter < NOTE_TIME - 1) begin
                note_counter <= note_counter + 1;
                lfsr_enable <= 1'b0;
            end
            else begin
                note_counter <= 0;
                lfsr_enable <= 1'b1; // pulse high for one clock cycle
            end
        end
    end

    // Select PWM period based on the 2-bit pseudo-random note selection
    always @(*) begin
      case (note_sel) // note_sel comes from LFSR.v
            2'd0: pwm_period = 22'd382219; // C4
            2'd1: pwm_period = 22'd340529; // D4
            2'd2: pwm_period = 22'd303371; // E4
            2'd3: pwm_period = 22'd286345; // F4
         //   default: pwm_period = 22'd382219;  
        endcase

        // 50% duty cycle for square wave audio
        pwm_duty = pwm_period >> 1;
    end

    // Send PWM output to speaker
    assign speaker = pwm_out;

endmodule
