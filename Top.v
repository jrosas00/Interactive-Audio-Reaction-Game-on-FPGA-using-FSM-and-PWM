`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineers: Michelle Herrera-Cuen, James Rosas
//
// Create Date: 03/26/2026 11:58:28 AM
// Design Name: Final Project
// Description: Connect FPGA to buttons
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input clk,
    input [5:0] btn,
    output [5:0] led
);

    wire [5:0] btn_press;
    reg  [5:0] led_reg = 6'b0; // Register for holding button value when pressed to output to LED

    // instantiate button module
    ButtonInput b0(
        .clk(clk),
        .btn(btn),
        .btn_press(btn_press)
    );

    always@(posedge clk)begin
        led_reg <= led_reg ^ btn_press; // toggles led_reg based off button presses
    end
    assign led = led_reg; // Turns on LED's based off button press
    
endmodule
