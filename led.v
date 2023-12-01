module HelloWorld (
    input wire clk,  // System clock
    output reg [7:0] leds // 8 LEDs
);

    reg [24:0] counter; // 25-bit counter to create delay

    always @(posedge clk) begin
        counter <= counter + 1; // Increment counter on every clock edge
        if (counter == 25'd24_999_999) begin // Adjust the count value based on your clock frequency
            leds <= ~leds; // Toggle LEDs
            counter <= 0; // Reset counter
        end
    end

    initial begin
        counter = 0; // Initialize counter
        leds = 0; // Initialize LEDs to be off
    end

endmodule
