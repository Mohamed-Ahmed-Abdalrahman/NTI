# UART Communication System: Simulation, Synthesis & Static Timing Analysis

This repository contains the complete Verilog HDL implementation, QuestaSim behavioral verification, and Xilinx Vivado hardware physical implementation for an asynchronous **Universal Asynchronous Receiver-Transmitter (UART)** system.

---

## 📐 System Architecture & Operation

The system consists of a transmitter (`uart_tx`) and receiver (`uart_rx`) operating at **115,200 Baud** from a **50 MHz** system clock ($f_{\text{clk}}$). 

### 1. Baud Rate Generation
The bit period is derived by dividing the system clock frequency by the target baud rate:
$$\text{BIT\_PERIOD} = \frac{f_{\text{clk}}}{\text{Baud Rate}} = \frac{50,000,000}{115,200} \approx 434 \text{ clock cycles}$$

An internal counter (`clk_cnt`) tracks clock ticks to trigger bit shifts and input sampling.

### 2. Transmitter (`uart_tx`)
Driven by a 4-state Finite State Machine (FSM):
* **IDLE:** Line held HIGH (`1`). Latches incoming 8-bit parallel data on `start` assertion.
* **START:** Pulls line LOW (`0`) for 1 bit period to notify the receiver.
* **DATA:** Sequentially shifts out 8 data bits (LSB first) over 8 bit periods via `bit_index`.
* **STOP:** Pulls line HIGH (`1`) for 1 bit period, lowers the `busy` flag, and returns to **IDLE**.

### 3. Receiver (`uart_rx`)
Uses a 4-state FSM with **Mid-Bit Sampling** to prevent noise glitches:
* **IDLE:** Monitors `rx_in` for a falling edge (`1` $\rightarrow$ `0`).
* **START:** Waits for half a bit period (`BIT_PERIOD / 2`). If line remains LOW, validates start bit.
* **DATA:** Samples incoming bits precisely at the center of each bit period (maximum signal stability) into a shift register.
* **STOP:** Asserts `rx_done` flag upon reconstructing the complete byte and returns to **IDLE**.

---

## 🛠️ Project Structure

```text
.
├── uart_tx.v           # 4-State Transmitter RTL
├── uart_rx.v           # 4-State Receiver RTL (Mid-Bit Sampling)
├── tb_uart.v           # Testbench for loopback verification
└── UART_Project.pdf    # Full report covering RTL, schematics & STA
📊 Verification & Implementation Analysis
1. Behavioral Simulation (QuestaSim)
The system logic was verified using an automated loopback testbench (tb_uart.v). The testbench instantiates both the transmitter and receiver, feeding a test byte payload into tx_data and checking the output of rx_data.
