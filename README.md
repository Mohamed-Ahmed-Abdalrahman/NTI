# UART Communication System Design & FPGA Implementation

This repository contains the Verilog HDL implementation, simulation, synthesis, and static timing analysis (STA) for a Universal Asynchronous Receiver-Transmitter (UART) communication system.

## 📌 Project Overview
The project implements a complete UART transmitter (`uart_tx`) and receiver (`uart_rx`) operating at a **115,200 Baud Rate** with a **50 MHz** system clock. The design uses 4-state Finite State Machines (FSMs) for precise bit generation and mid-bit sampling.

### Key Features
* **Asynchronous Communication:** 8-bit data frame with 1 Start Bit and 1 Stop Bit.
* **Baud Rate Generator:** Internal clock divider mapping $50\text{ MHz} \rightarrow 115,200\text{ baud}$.
* **Mid-Bit Sampling:** Receiver samples at `BIT_PERIOD / 2` to eliminate line noise and ensure signal stability.
* **FPGA Verified:** Elaborated, synthesized, and implemented using Xilinx Vivado.
### 1. Transmitter (`uart_tx`)
Driven by a 4-state Finite State Machine (FSM):
* **IDLE:** Line held HIGH (`1`). Latches incoming 8-bit parallel data on `start` assertion.
* **START:** Pulls line LOW (`0`) for 1 bit period to notify the receiver.
* **DATA:** Sequentially shifts out 8 data bits (LSB first) over 8 bit periods via `bit_index`.
* **STOP:** Pulls line HIGH (`1`) for 1 bit period, lowers the `busy` flag, and returns to **IDLE**.

### 2. Receiver (`uart_rx`)
Uses a 4-state FSM with **Mid-Bit Sampling** to prevent noise glitches:
* **IDLE:** Monitors `rx_in` for a falling edge (`1` $\rightarrow$ `0`).
* **START:** Waits for half a bit period (`BIT_PERIOD / 2`). If line remains LOW, validates start bit.
* **DATA:** Samples incoming bits precisely at the center of each bit period (maximum signal stability) into a shift register.
* **STOP:** Asserts `rx_done` flag upon reconstructing the complete byte and returns to **IDLE**.

---

## 3. 🔍 Behavioral Verification (QuestaSim)

The design logic was verified in **QuestaSim** using an automated loopback testbench (`tb_uart.v`) that connects the transmitter output directly to the receiver input.

### Test Environment & Strategy
* **Data Payload:** Transmitted `8'hA5` (`8'b10100101`) to verify alternating 1s and 0s.
* **Automated Checker:** Compares the final byte output in `rx_data` against the input `tx_data` upon assertion of `rx_done`.

  ## 4. 🛠️ Project Structure
  .
* ├── uart_tx.v           # 4-State Transmitter RTL
* ├── uart_rx.v           # 4-State Receiver RTL (Mid-Bit Sampling)
* ├── tb_uart.v           # Testbench for loopback verification
*└── UART_Project.pdf    # Full report covering RTL, schematics & STA

## 5. Static Timing Analysis (STA)
<img width="1025" height="224" alt="image" src="https://github.com/user-attachments/assets/75b08d8e-e68f-45f0-bb73-bf205ca17d57" />



