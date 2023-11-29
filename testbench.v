`timescale 1ns / 1ps

module TemporalThermalCovertChannel_tb;

    // Inputs to the UUT
    reg clk;
    reg reset;
    reg enable;

    // Outputs from the UUT
    wire [19:0] counter_output;
    wire [7:0] leds;

    // Instantiate the Unit Under Test (UUT)
    TemporalThermalCovertChannel uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .counter_output(counter_output),
        .leds(leds)
    );

    // Clock generation
    always #10 clk = ~clk; // Generate a clock with a period of 20ns (50 MHz)

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        enable = 0;

        // Apply a reset
        #100;
        reset = 0;

        // Enable the module after some time
        #50; 
        enable = 1;
        
        // Run the simulation for some time to observe the behavior
        #1000;

        // Disable the module to check the behavior
        enable = 0;
        #100;

        // Apply a reset again
        reset = 1;
        #50;
        reset = 0;

        // Enable the module once more
        #50; 
        enable = 1;
        #1000;

        // End of the simulation
        $finish;
    end
      
endmodule
