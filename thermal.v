module TemporalThermalCovertChannel (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [19:0] counter_output,
    output reg comm_pin
);

    reg [74:0] ring_oscillator;
    reg [19:0] counter;

    // The Ring Oscillator with 75 Inverters
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ring_oscillator <= 75'b0;
        end else if (enable & ring_oscillator[74]) begin
            ring_oscillator <= ~ring_oscillator;
        end
    end

    // From the instructions
    (* keep = "true" *) reg [74:0] ro_keep = ring_oscillator;

    // 20-bit Counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 20'b0;
        end else if (enable & ring_oscillator[74]) begin
            counter <= counter + 1'b1;
        end
    end

    assign counter_output = counter;

    // Some Communication Logic idk if this is gonna work
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            comm_pin <= 0;
        end else begin
            comm_pin <= counter[19];
        end
    end

endmodule
