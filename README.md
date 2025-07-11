# Crossy Roads/Frogger Game Board

Game Overview
Objective: Move the frog from the bottom (row 15) to the top (row 0) without hitting a car.

Controls (KEY buttons on DE1-SoC):

KEY0: Right

KEY1: Up

KEY2: Down

KEY3: Left

Win Condition: Reach row 0 without a crash.

Crash Condition: A green (frog) pixel overlaps a red (car) pixel.

Feedback:

VICTOR on HEX displays = win

CRASH on HEX displays = game over

Game resets after a short delay.

Features and Highlights
- Randomized car movement using LFSRs
- Debounced, noise-resistant button inputs
- Real-time crash and victory detection
- HEX display message system with timer
- Modular design for clarity and reusability

File Breakdown
File	Description
DE1_SoC.sv	Top-level integration of all game modules
frogTracker.sv	Tracks frog's position and updates green pixels
carMovement.sv	Controls car positions using LFSRs
LFSR.sv	Pseudo-random number generator for cars
crashDetection.sv	Detects overlap between frog and cars
victoryCheck.sv	Detects when frog reaches row 0
messageDisplay.sv	Displays VICTOR or CRASH using HEX displays
counter.sv	Delays game reset after a crash or win
clock_divider.sv	Generates slow clock for movement timing
dFlipFlop.sv	Button debouncing and noise immunity
LEDDriver.sv	Sends grid data to external 16x16 LED board
testbenches/	Module-level simulations for validation

💻 How to Run
Open the project in Quartus Prime.

Compile and upload the design to the DE1-SoC board.

Connect a 16x16 LED grid via GPIO_1.

Use the buttons to move the frog.

Watch the LEDs and HEX displays for game feedback.

⚙️ Requirements
DE1-SoC FPGA development board

Quartus Prime software

16x16 LED Matrix (wired to GPIO_1)

USB Blaster cable for programming

🛠 Skills Demonstrated
Hardware programming with Verilog

Finite State Machine (FSM) design

Signal debouncing and flip-flop implementation

LFSR-based randomization

Collision detection and condition logic

Resource-aware modular FPGA design

📊 FPGA Resource Usage
390 Combinational Lookup Tables (LUTs)

211 Logic Registers

These values reflect a low-to-moderate hardware footprint, leaving room for future features.
