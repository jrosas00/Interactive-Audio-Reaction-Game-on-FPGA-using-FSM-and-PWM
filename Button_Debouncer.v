`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Michelle Herrera-Cuen, James Rosas
// 
// Create Date: 04/04/2026 12:23:06 AM
// Design Name: 
// Module Name: Button_Debouncer
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


module Button_Debouncer #(parameter DELAY = 1000000) // 1 million at 100MHZ is a 10ms debounce rate
(   input  wire clk,
    input  wire BUTTON,
    output wire RISING_EDGE_PULSE, // Use this to detect button as soon as it goes high
    output wire FALLING_EDGE_PULSE // Use this to detect button as sson as it goes low
    );
    
    // 1. Synchronize asynchronous button input
    reg[1:0] button_sync_raw = 2'b00;
    always @(posedge clk)begin
        button_sync_raw[0] <= BUTTON;
        button_sync_raw[1] <= button_sync_raw[0];
        end
        
    // 2. Debounce Logic (filters contact bounce)
    wire BUTTON_DEBOUNCED;
    noise_remover #(DELAY) IN0(
        .clk(clk),
        .debouncer_input(button_sync_raw[1]),
        .debouncer_output(BUTTON_DEBOUNCED)
     );
     
     // 3. Edge Detection (1 cycle pulses)
     reg [1:0] button_sync = 2'b00;
     always@(posedge clk)begin
        button_sync[0] <= BUTTON_DEBOUNCED; // Current Button Value
        button_sync[1] <= button_sync[0];   // Previous Button Value due to non-blocking assignment
        end
     assign RISING_EDGE_PULSE  = (button_sync == 2'b01); // Original button value is 0 and then pressed to create 1
     assign FALLING_EDGE_PULSE = (button_sync == 2'b10); // Original button value is 1 and released to create 0
        
endmodule

module noise_remover #(parameter DELAY = 1000000) // 1 million at 100MHZ is a 10ms debounce rate
(
    input wire clk,
    input wire debouncer_input,
    output reg debouncer_output = 0
);
    localparam COUNTER_BITS = $clog2(DELAY); // $clog2 is built in function. returns ceiling of log base 2 of x
    reg[COUNTER_BITS:0] counter = 0; // Creates the required bits for the counter size
    
    always@(posedge clk)begin
        // When input is changed will start counting until counter is reached, to debounce
        if(debouncer_input != debouncer_output)begin
            if(counter < (DELAY - 1))begin
                counter <= counter + 1'b1;            
            end
            
            else begin
                debouncer_output <= debouncer_input;
                counter <= 0;
            end    
        end
        
        // If input matches current output then reset counter
        else begin // Input = Output
        counter <= 0;
        end
     end
endmodule        
