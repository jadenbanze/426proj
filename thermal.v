module TemporalThermalCovertChannel (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [19:0] counter_output,
    output reg [7:0] leds
);

    reg [74:0] ring_oscillator;
    reg [19:0] counter;
    reg last_ring_bit; // Intermediate signal for ring_oscillator[74]
    reg [31:0] display_timer; // 32-bit timer to manage display intervals

    // The Ring Oscillator with 75 Inverters
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ring_oscillator <= 75'b0;
            last_ring_bit <= 0;
        end else if (enable) begin
            ring_oscillator <= ~ring_oscillator;
            last_ring_bit <= ring_oscillator[74];
        end
    end

    // 20-bit Counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 20'b0;
        end else if (enable & last_ring_bit) begin
            counter <= counter + 1'b1;
        end
    end

    // Update counter_output
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter_output <= 20'b0;
        end else if (enable & last_ring_bit) begin
            counter_output <= counter;
        end
    end

    // Display Timer Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            display_timer <= 32'b0;
        end else begin
            display_timer <= display_timer + 1'b1;
        end
    end

    // LED Display Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            leds <= 8'b0;
        end else begin
            case (display_timer[19:17]) // Using bits 17 to 19 of the timer to cycle through displays
                3'b000, 3'b001: leds <= counter[7:0];   // First 8 bits
                3'b010, 3'b011: leds <= counter[15:8];  // Next 8 bits
                3'b100, 3'b101: leds <= {6'b0, counter[19:16]}; // Last 4 bits, padded with zeros
                default: leds <= 8'b0;
            endcase
        end
    end

endmodule
