module TemporalThermalCovertChannel (
    input wire clk,      // Clock input
    input wire reset,    // Reset button
    output reg led1, led2, led3, led4 // 4 LED outputs as reg
);

    reg [74:0] ring_oscillator; // Using a large number for more heat generation

    // The Ring Oscillator with Inverters in Series
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ring_oscillator <= {75{1'b1}}; // Initialize with all 1's
        end else begin
            ring_oscillator[0] <= ~ring_oscillator[74];
            ring_oscillator[74:1] <= ring_oscillator[73:0];
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            {led1, led2, led3} <= 3'b111; // Turn on LEDs 1, 2, and 3
            led4 <= 1'b0;                 // Initialize LED 4
        end else begin
            {led1, led2, led3} <= 3'b111; // Keep LEDs 1, 2, and 3 constantly on
            led4 <= ring_oscillator[0];   // Display the state of the ring oscillator on LED 4
        end
    end

    // Prevent optimization of the ring oscillator
    (* DONT_TOUCH = "true" *) wire prevent_optimization = &ring_oscillator;

endmodule
