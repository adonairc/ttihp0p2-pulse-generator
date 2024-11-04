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

   
    widths = [100,200,150,250,300,50,400,100,500,125,350,275,450,150,225,275]
    periods = [1000,1200,1100,1500,2000,800,2500,900,3000,1000,2200,1800,2800,1300,1700,1900]
    counts = [10,8,12,5,15,20,7,10,4,14,6,9,3,11,13,16]


    # Test sequences
    for sequence in range(len(widths)):
        dut._log.info(f"Testing pulse sequence #{sequence}")
         # Reset
        dut.ena.value = 1
        dut.rst_n.value = 0
        await ClockCycles(dut.clk, 1)

        dut.rst_n.value = 1
        dut.ui_in.value = sequence

        await ClockCycles(dut.clk, 2)
        assert dut.uo_out.value == 0
      
        # Wait for one clock cycle to reg input
        await ClockCycles(dut.clk, widths[sequence])
        assert dut.uo_out.value == 1
        