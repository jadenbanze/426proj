module TemporalThermalCovertChannel (
    input wire clk,
    input wire reset,
    output reg [19:0] counter_output,
    output reg [7:0] leds
);

    reg [74:0] ring_oscillator;
    reg [19:0] counter;
    reg last_ring_bit; // Intermediate signal for ring_oscillator[74]
    reg [31:0] display_timer; // 32-bit timer to manage display intervals
    reg [31:0] second_counter; // Second counter for 60-second intervals

    // The Ring Oscillator with 75 Inverters
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ring_oscillator <= 75'b0;
            last_ring_bit <= 0;
        end else begin
            ring_oscillator <= ~ring_oscillator;
            last_ring_bit <= ring_oscillator[74];
        end
    end

    // 20-bit Counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 20'b0;
        end else if (last_ring_bit) begin
            counter <= counter + 1'b1;
        end
    end

    // Update counter_output and Reset Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter_output <= 20'b0;
            second_counter <= 0;
        end else begin
            second_counter <= second_counter + 1;
            if (second_counter >= 12_000_000 * 60) begin // For a 12 MHz clock
                counter_output <= counter;
                second_counter <= 0;
                counter <= 0; // Resetting the counter
            end
        end
    end

    // LED Display Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            leds <= 8'b0;
        end else if (second_counter >= 12_000_000 * 60 - 1) begin
            // Display the counter value on LEDs for a short period before reset
            leds <= counter_output[7:0]; // Display the lower 8 bits of the counter
        end else begin
            leds <= 8'b0;
        end
    end

endmodule
