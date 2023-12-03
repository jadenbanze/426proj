module TemporalThermalCovertChannel (
    input wire clk, // Clock input
    output reg led1, led2, led3, led4 // 4 LED outputs as reg
);

    reg [74:0] ring_oscillator;
    reg [19:0] counter;
    reg last_ring_bit; // Intermediate signal for ring_oscillator[74]
    reg [31:0] display_timer; // Timer for controlling the LED display

    // The Ring Oscillator with 75 Inverters
    always @(posedge clk) begin
        ring_oscillator <= ~ring_oscillator;
        last_ring_bit <= ring_oscillator[74];
        
        // Increment counter
        if (last_ring_bit) begin
            counter <= counter + 1'b1;
        end

        // Update display timer
        display_timer <= display_timer + 1;
    end

    // LED Display Logic
    always @(posedge clk) begin
        case (display_timer[23:22]) // Using higher bits to divide the time
            2'b00: {led1, led2, led3, led4} <= 4'b0;                                 // All LEDs off for the first interval
            2'b01: {led1, led2, led3, led4} <= counter[3:0];                         // Display first 4 bits of the counter
            2'b10: {led1, led2, led3, led4} <= counter[7:4];                         // Display next 4 bits of the counter
            2'b11: {led1, led2, led3, led4} <= counter[11:8];                        // Display the next 4 bits of the counter
            default: {led1, led2, led3, led4} <= 4'b0;
        endcase
    end

endmodule
