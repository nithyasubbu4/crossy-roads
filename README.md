This project implements a simplified version of the classic **Frogger** game, similar to the mobile app game called crossy roads, on a **DE1-SoC FPGA**. The player controls a frog trying to cross a road of moving cars. The game is displayed on a 16x16 LED grid, and uses push-buttons for movement.

---

## Game Overview

- **Objective:** Move the frog from the bottom (row 15) to the top (row 0) without colliding with any cars.
- **Controls:**
  - `KEY0`: Right
  - `KEY1`: Up
  - `KEY2`: Down
  - `KEY3`: Left
- **Victory:** Reaching the top row (`row 0`)
- **Crash:** Frog overlaps with a car (Red and Green pixels collide)
- **Feedback:**
  - `VICTOR` appears on the HEX display when the frog wins
  - `CRASH` appears when the frog collides with a car
  - After a short delay, the board resets for a new round

---

## Features

- Random car movement using LFSRs
- Noise-resistant button inputs with flip-flops
- FSM-based message display system
- Real-time collision detection
- Modular Verilog design for readability and scalability
- HEX display for event feedback

---

## File Descriptions

| File | Description |
|------|-------------|
| `DE1_SoC.sv` | Top-level module integrating all subsystems |
| `frogTracker.sv` | Handles frog movement and grid updates |
| `carMovement.sv` | Controls car lanes with LFSRs |
| `LFSR.sv` | Linear Feedback Shift Register for randomness |
| `crashDetection.sv` | Detects collision between frog and cars |
| `victoryCheck.sv` | Checks if frog has reached the top row |
| `messageDisplay.sv` | Manages HEX display output (CRASH/VICTOR) |
| `counter.sv` | Delay timer for display reset |
| `clock_divider.sv` | Generates slower clock from 50MHz input |
| `dFlipFlop.sv` | Implements noise-immune button controls |
| `LEDDriver.sv` | Interfaces with 16x16 external LED matrix |
| `testbenches/` | Contains simulation files for module testing |

---

## Setup Instructions

1. Clone the repo and open the project in **Quartus Prime**.
2. Connect the **DE1-SoC** board and program it using the .sof file.
3. Connect a **16x16 LED Matrix** to the `GPIO_1` header.
4. Use the pushbuttons to control the frog.
5. Watch the LED grid and HEX displays to track progress.

---

## Hardware Requirements

- DE1-SoC FPGA board
- Quartus Prime Software
- USB Blaster cable
- 16x16 LED Matrix (connected to `GPIO_1`)

---

## Resource Utilization

- **390** Combinational Lookup Tables (LUTs)
- **211** Logic Registers  
> Efficient usage, with plenty of room for future expansion.

---

## Skills Demonstrated

- Verilog HDL programming
- Finite State Machine (FSM) design
- Random number generation using LFSRs
- Button debouncing and edge detection
- Collision detection logic
- LED matrix interfacing and timing
- Modular, resource-conscious hardware design

---

## Demo & Diagrams
Block Diagrams: 
- [EE 271.pdf](https://github.com/user-attachments/files/21173961/EE.271.pdf)
- [block diagram.pdf](https://github.com/user-attachments/files/21173973/block.diagram.pdf)

