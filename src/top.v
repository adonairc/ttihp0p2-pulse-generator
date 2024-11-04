/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_pulse_generator (
    input  wire [7:0] ui_in,    // First 4-bit input to select the pulse sequence
    output wire [7:0] uo_out,   // Signal output
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
  reg[3:0] reg_sequence_select;
  wire [3:0] sequence_select;

  assign sequence_select = reg_sequence_select;

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7:1] = 0;
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

  // Pre-configured pulse parameters for each sequence
  reg [31:0] pulse_width[15:0];  // Pulse width for each sequence
  reg [31:0] pulse_period[15:0]; // Pulse period for each sequence
  reg [15:0] pulse_count[15:0];  // Pulse count for each sequence

  // Selected pulse parameters
  reg [31:0] selected_pulse_width;
  reg [31:0] selected_pulse_period;
  reg [15:0] selected_pulse_count;

  // Initialize configurations (add as needed)
  initial begin

        // Sequence 0
        pulse_width[0] = 32'd100;
        pulse_period[0] = 32'd1000;
        pulse_count[0] = 16'd10;

        // Sequence 1
        pulse_width[1] = 32'd200;
        pulse_period[1] = 32'd1200;
        pulse_count[1] = 16'd8;

        // Sequence 2
        pulse_width[2] = 32'd150;
        pulse_period[2] = 32'd1100;
        pulse_count[2] = 16'd12;

        // Sequence 3
        pulse_width[3] = 32'd250;
        pulse_period[3] = 32'd1500;
        pulse_count[3] = 16'd5;

        // Sequence 4
        pulse_width[4] = 32'd300;
        pulse_period[4] = 32'd2000;
        pulse_count[4] = 16'd15;

        // Sequence 5
        pulse_width[5] = 32'd50;
        pulse_period[5] = 32'd800;
        pulse_count[5] = 16'd20;

        // Sequence 6
        pulse_width[6] = 32'd400;
        pulse_period[6] = 32'd2500;
        pulse_count[6] = 16'd7;

        // Sequence 7
        pulse_width[7] = 32'd100;
        pulse_period[7] = 32'd900;
        pulse_count[7] = 16'd10;

        // Sequence 8
        pulse_width[8] = 32'd500;
        pulse_period[8] = 32'd3000;
        pulse_count[8] = 16'd4;

        // Sequence 9
        pulse_width[9] = 32'd125;
        pulse_period[9] = 32'd1000;
        pulse_count[9] = 16'd14;

        // Sequence 10
        pulse_width[10] = 32'd350;
        pulse_period[10] = 32'd2200;
        pulse_count[10] = 16'd6;

        // Sequence 11
        pulse_width[11] = 32'd275;
        pulse_period[11] = 32'd1800;
        pulse_count[11] = 16'd9;

        // Sequence 12
        pulse_width[12] = 32'd450;
        pulse_period[12] = 32'd2800;
        pulse_count[12] = 16'd3;

        // Sequence 13
        pulse_width[13] = 32'd150;
        pulse_period[13] = 32'd1300;
        pulse_count[13] = 16'd11;

        // Sequence 14
        pulse_width[14] = 32'd225;
        pulse_period[14] = 32'd1700;
        pulse_count[14] = 16'd13;

        // Sequence 15
        pulse_width[15] = 32'd275;
        pulse_period[15] = 32'd1900;
        pulse_count[15] = 16'd16;
  end

  // Update selected parameters based on sequence_select
  always @(*) begin
      selected_pulse_width = pulse_width[sequence_select];
      selected_pulse_period = pulse_period[sequence_select];
      selected_pulse_count = pulse_count[sequence_select];
  end

  // Registering the input signal from ui_in pins to avoid metastability
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
       reg_sequence_select <= 0;
    end else begin
      reg_sequence_select <= ui_in[3:0];
    end
  end

  // Instantiate the single-channel TTL Pulse Generator
  ttl_pulse_generator pulse_gen_inst (
      .clk(clk),
      .rst_n(rst_n),
      .pulse_width(selected_pulse_width),
      .pulse_period(selected_pulse_period),
      .pulse_count(selected_pulse_count),
      .ttl_out(uo_out[0])
  );

endmodule