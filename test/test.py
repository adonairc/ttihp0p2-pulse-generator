# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 ns (100 MHz)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.uio_in.value = 0
    dut.rst_n.value = 0


    dut._log.info("Test pulse sequence #0")
    dut.ui_in.value = 0

    # Wait for one clock cycle to reg input
    await ClockCycles(dut.clk, 1)
    print("Output at clk #1 = ",dut.uo_out.value)
    # pulse_width[0] = 32'd100;
    # pulse_period[0] = 32'd1000;
    # pulse_count[0] = 16'd10;


    await ClockCycles(dut.clk, 100)
    print("Output at clk #100 = ",dut.uo_out.value)
    # dut.rst_n.value = 1


    # Set the input values you want to test
    # dut.ui_in.value = 20
    # dut.uio_in.value = 30

    # Wait for one clock cycle to see the output values
    # await ClockCycles(dut.clk, 1)

    # The following assersion is just an example of how to check the output values.
    # Change it to match the actual expected output of your module:
    # assert dut.uo_out.value == 50

    # Keep testing the module by changing the input values, waiting for
    # one or more clock cycles, and asserting the expected output values.
