`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSULB
// Engineers: Michelle Herrera-Cuen, James Rosas
// 
// Create Date: 03/26/2026 11:58:45 AM
// Module Name: Top_tb
// Project Name: Final Project
// Description: Testbench to test button presses
// 
//////////////////////////////////////////////////////////////////////////////////

// Button should debounce after being stable for atleast 10ms, parameter for delay is in Button_Debouncer.v
module Top_tb;
    reg clk;
    reg[5:0] btn;
    wire[5:0] led; 
    
    // DUT
    Top uut(   
        .clk(clk),
        .btn(btn),
        .led(led)
    );
    
    // 100 MHz clock  10 ns period
    always#5 clk = ~clk;
    
    integer i;
    initial begin
        clk = 0;
        btn = 6'b000000;  
        #100;
        
        // To test buttons after debounce threshold of 10ms
     //   for(i = 0; i < 64; i = i + 1)begin
      //     btn = i[5:0];
        //   #12000000;   // hold for 12 ms
         //  btn = 6'b000000;
       //    #12000000;   // release for 12 ms
      //  end
   
        // To test buttons before debounce threshold  < 10ms
     for(i = 0; i < 64; i = i + 1)begin
            btn = i[5:0];
            #9000000;   // hold for 9 ms
            btn = 6'b000000;
            #9000000;   // release for 9 ms
        end
        
        
        $stop;
     end
     
endmodule
