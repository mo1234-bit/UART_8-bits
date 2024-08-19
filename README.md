# 8-bit UART (Universal Asynchronous Receiver/Transmitter)

## Overview

This project implements a full 8-bit Universal Asynchronous Receiver/Transmitter (UART) in Verilog. UART is a commonly used protocol for serial communication, where data is transmitted and received one bit at a time.

The project includes:
- An 8-bit UART transmitter module for sending serial data.
- An 8-bit UART receiver module for receiving serial data and converting it into parallel data.
- A baud rate generator for precise timing control.
- A testbench for simulating and verifying the functionality of the complete UART system.

## Features

- Supports 8-bit data frames.
- Handles standard UART frame format: 1 start bit, 8 data bits, and 1 stop bit.
- Configurable baud rate through the `s_tick` signal, controlled by a baud rate generator.
- One-hot encoded state machine for efficient state management.
- Full-duplex communication supported by both transmitting and receiving modules.
- Baud rate timing for accurate serial communication.

## Project Structure

- `uart_tx.v`: Verilog module implementing the 8-bit UART transmitter.
- `uart_rx.v`: Verilog module implementing the 8-bit UART receiver.
- `baud_rate_gen.v`: Verilog module generating the baud rate timing signals.
- `uart_top.v`: Top-level Verilog module that integrates the transmitter, receiver, and baud rate generator.
- `uart_tb.v`: Testbench for simulating and verifying the complete UART system.
- `README.md`: Project documentation.
- `LICENSE`: Project license.

## Getting Started

### Prerequisites

To work with this project, you'll need:
- A Verilog simulator (e.g., ModelSim, Vivado, or Icarus Verilog).
- Basic understanding of digital logic design, UART protocol, and Verilog HDL.

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/8-bit-UART.git
   cd 8-bit-UART
