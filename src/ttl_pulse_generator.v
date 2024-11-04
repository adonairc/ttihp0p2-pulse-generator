module ttl_pulse_generator (
    input wire clk,                   // System clock
    input wire rst_n,                 // Active-low reset
    input wire [31:0] pulse_width,    // Pulse width (in clock cycles)
    input wire [31:0] pulse_period,   // Pulse period (in clock cycles)
    input wire [15:0] pulse_count,    // Number of pulses
    output reg ttl_out                // Output TTL signal
);

    reg [31:0] pulse_counter;
    reg [31:0] period_counter;
    reg [15:0] count_counter;
    reg pulse_active;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset counters and output
            pulse_counter <= 0;
            period_counter <= 0;
            count_counter <= 0;
            ttl_out <= 0;
            pulse_active <= 0;
        end else if (pulse_active) begin
            // Generate pulse logic
            if (pulse_counter < pulse_width) begin
                ttl_out <= 1;
                pulse_counter <= pulse_counter + 1;
            end else begin
                ttl_out <= 0;
            end

            // Manage period and pulse count
            if (period_counter < pulse_period) begin
                period_counter <= period_counter + 1;
            end else begin
                period_counter <= 0;
                pulse_counter <= 0;

                // Decrease pulse count
                if (count_counter > 0) begin
                    count_counter <= count_counter - 1;
                end

                // Stop generating pulses if count reaches zero
                if (count_counter == 1) begin
                    pulse_active <= 0;
                end
            end
        end else begin
            // Activate new pulse sequence
            if (count_counter == 0) begin
                count_counter <= pulse_count;
                pulse_active <= 1;
            end
        end
    end
endmodule