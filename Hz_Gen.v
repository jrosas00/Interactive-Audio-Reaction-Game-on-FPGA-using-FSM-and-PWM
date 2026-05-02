`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineer: James Rosas, Michelle Herrera-Cuen
// 
// Create Date: 04/11/2026 09:38:35 PM
// Design Name: 
// Module Name: Hz_Gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Hz_Gen is used for the 7 segment display digit switching frequency
//////////////////////////////////////////////////////////////////////////////////


module Hz_Gen(
    input clk,
    input reset,
    output clk_7_segment // Currently set to 500 Hz
    );
    
    reg [22:0] ctr_reg = 0; // 23 bits to cover up to 5,000,000 which would allow up to 10Hz
    reg clk_out_reg = 0;
    
    always@(posedge clk or posedge reset)
        if(reset) begin
            ctr_reg <= 0;
            clk_out_reg <= 0;
        end
        else
            if(ctr_reg == 99_999) begin // 100MHz / 500Hz / 2 = 100,000 ,change this value according to what Hz you want
                ctr_reg <= 0;
                clk_out_reg <= ~clk_out_reg;
            end
            else
                ctr_reg <= ctr_reg +1;
     assign clk_7_segment = clk_out_reg;                   
            
    
endmodule
