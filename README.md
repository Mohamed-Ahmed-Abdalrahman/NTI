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

## 🔍 Behavioral Verification (QuestaSim)

The design logic was verified in **QuestaSim** using an automated loopback testbench (`tb_uart.v`) that connects the transmitter output directly to the receiver input.

### Test Environment & Strategy
* **Data Payload:** Transmitted `8'hA5` (`8'b10100101`) to verify alternating 1s and 0s.
* **Automated Checker:** Compares the final byte output in `rx_data` against the input `tx_data` upon assertion of `rx_done`.

  ## 🛠️ Project Structure
  .
* ├── uart_tx.v           # 4-State Transmitter RTL
* ├── uart_rx.v           # 4-State Receiver RTL (Mid-Bit Sampling)
* ├── tb_uart.v           # Testbench for loopback verification
*└── UART_Project.pdf    # Full report covering RTL, schematics & STA

## Static Timing Analysis (STA)
<img width="1025" height="224" alt="image" src="https://github.com/user-attachments/assets/75b08d8e-e68f-45f0-bb73-bf205ca17d57" />




