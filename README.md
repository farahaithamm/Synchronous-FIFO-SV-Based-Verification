# Synchronous FIFO Verification

> **By:** Farah Haitham Saddik

This project implements a **Synchronous FIFO (First-In, First-Out)** buffer for reliable data transfer between modules operating on the same clock domain.
The FIFO supports configurable data width and depth, featuring efficient read/write operations, pointer wraparound, and status flags for full, empty, almost full, and almost empty conditions.
It is suitable for applications that require temporary data storage, flow control, and sequential data integrity in digital systems.

## Overview

This project involves a SystemVerilog verification environment is included to validate the design’s functionality using constrained-random testing, assertion-based verification (SVA), and a scoreboard-driven self-checking mechanism to ensure correct operation under all conditions.

## Specifications 
- **FIFO_WIDTH**: Data in/out and memory word width (default: 16)
- **FIFO_DEPTH**: Memory depth (default: 8)

### Ports:

| Port        | Direction | Function |
|--------------|------------|-----------|
| data_in     | Input      | **Write Data:** The input data bus used when writing the FIFO. |
| wr_en       | Input      | **Write Enable:** If the FIFO is not full, asserting this signal causes data (on `data_in`) to be written into the FIFO. |
| rd_en       | Input      | **Read Enable:** If the FIFO is not empty, asserting this signal causes data (on `data_out`) to be read from the FIFO. |
| clk         | Input      | **Clock signal.** |
| rst_n       | Input      | **Active low asynchronous reset.** |
| data_out    | Output     | **Read Data:** The sequential output data bus used when reading from the FIFO. |
| full        | Output     | **Full Flag:** When asserted, this combinational output signal indicates that the FIFO is full. Write requests are ignored when the FIFO is full. Initiating a write when the FIFO is full is not destructive to the contents of the FIFO. |
| almostfull  | Output     | **Almost Full:** When asserted, this combinational output signal indicates that only one more write can be performed before the FIFO is full. |
| empty       | Output     | **Empty Flag:** When asserted, this combinational output signal indicates that the FIFO is empty. Read requests are ignored when the FIFO is empty. Initiating a read while empty is not destructive to the FIFO. |
| almostempty | Output     | **Almost Empty:** When asserted, this combinational output signal indicates that only one more read can be performed before the FIFO goes to empty. |
| overflow    | Output     | **Overflow:** This sequential output signal indicates that a write request (`wr_en`) was rejected because the FIFO is full. Overflowing the FIFO is not destructive to the contents of the FIFO. |
| underflow   | Output     | **Underflow:** This sequential output signal indicates that the read request (`rd_en`) was rejected because the FIFO is empty. Underflowing the FIFO is not destructive to the FIFO. |
| wr_ack      | Output     | **Write Acknowledge:** This sequential output signal indicates that a write request (`wr_en`) has succeeded. |


## Testbench Overview

The **SystemVerilog testbench** is designed to verify the functionality of the Synchronous FIFO through a self-checking and coverage-driven environment.

1. The **top module** generates the clock and provides it to the testbench interface.  
2. The **testbench** resets the FIFO, randomizes the input signals, performs write/read operations.  
3. A **monitor** continuously samples the interface signals, validates the output data, and records coverage metrics.

### Main Components

- **FIFO_transaction_pkg** – Defines and randomizes FIFO transaction data used during testing.  
- **FIFO_scoreboard** – Compares the DUT output with a reference model to detect mismatches and count errors.  
- **FIFO_coverage_pkg** – Implements functional coverage collection using a covergroup that tracks `wr_en`, `rd_en`, and FIFO control signals.

### Functional Coverage

Comprehensive **cross-coverage** is implemented between `wr_en`, `rd_en`, and all status flags to ensure every possible FIFO state and transition is exercised during simulation.

### Assertions

**SystemVerilog Assertions (SVA)** are applied to monitor all output flags (except `data_out`) and internal counters.  
They verify that the FIFO maintains correct behavior under all timing and control conditions.  
Assertions are conditionally compiled to allow flexible inclusion during verification.

## Project Structure

├── RTL/                               # the RTL design files for the FIFO
├── SV Based Verification/             # Verification related files
└── Project_Report.pdf                 # Detailed project report

## Getting Started

To work with this project, you’ll need a **Verilog/SystemVerilog simulator** that supports behavioral and RTL simulation.  
**QuestaSim** (Mentor Graphics) is recommended for best results.

### 1. Quick Simulation (Recommended)

A preconfigured script `run_fifo.do` is provided to automate the simulation process.

**Steps:**
1. Ensure your simulator is properly installed and licensed.  
2. Open a terminal or simulator console.  
3. Navigate to the project directory.  
4. Run the following command: do run.do
5. The script will automatically:
- Compile all Verilog and SystemVerilog source files.  
- Load the testbench environment.  
- Run the simulation.  
- Display the waveform in the simulator.  

### 2. Manual Simulation (Optional)

If you prefer to run the simulation manually, follow these steps:

1. Compile the FIFO RTL design files from the `RTL/AFTER MODIFICATION` directory.  
2. Compile the SystemVerilog testbench files from the `SV Based Verification/` directory.  
3. Load the top-level testbench module `FIFO_top`.  
4. Run the simulation and observe the waveform and console output.  

### 3. Testbench

- The provided `FIFO_top.sv` module includes random write/read transactions and coverage collection.  
- You can extend the testbench with custom sequences or assertions to explore additional scenarios.  
- Simulation results and coverage reports can be found in the output directory after execution.  

