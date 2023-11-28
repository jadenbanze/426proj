`timescale 1ns / 1ps

module TemporalThermalCovertChannel_tb;

    // Inputs
    reg clk;
    reg reset;
    reg enable;

    // Outputs
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
    always #10 clk = ~clk; // 50MHz clock

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        enable = 0;

        // Wait for global reset
        #100;
        reset = 0;

        // Enable the counter and observe the LEDs and counter output
        #20 enable = 1;
        
        // Observe the output for some time
        #1000;

        // Disable and check outputs
        enable = 0;
        #100;

        // Reset the system and observe
        reset = 1;
        #100;
        reset = 0;

        // Enable again to check if system resumes correctly
        #20 enable = 1;
        #1000;

        // Finish the simulation
        $finish;
    end
      
endmodule
