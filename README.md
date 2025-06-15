# 8-Bit VHDL Calculator

A complete 8-bit calculator designed in VHDL for FPGA implementation. It performs signed addition and subtraction using two's complement and displays results via 7-segment displays.
*THIS WAS DONE AS A GROUP EFFORT WITH CLASSMATES*

> A hardware-based arithmetic unit demonstrating modular design and overflow detection in VHDL.

---

## Overview

This project is an 8-bit calculator designed entirely in VHDL for implementation on an FPGA. The system functions as a simple arithmetic unit capable of performing signed addition and subtraction on 8-bit operands. The calculator is controlled by a 4-bit opcode to select specific operations, such as X + Y, Y – X, and Y – 1. A key aspect of the design is its ability to handle signed numbers using two's complement arithmetic and to detect and flag arithmetic overflows. The final 8-bit result is displayed on a pair of 7-segment displays for clear visual feedback.

---

## Features

- **Signed Arithmetic**: The calculator performs addition and subtraction on signed 8-bit operands. Subtraction is implemented using the two's complement method (Y + (-X)).

- **Opcode-Based Control**: A 4-bit opcode determines which arithmetic operation is executed, allowing for flexible control of the unit.

- **Modular VHDL Design**: The system is built structurally from several smaller, reusable VHDL components, including two 8-bit registers, a main processing unit, an 8-bit adder, and 7-segment display drivers.

- **Overflow Detection**: Includes dedicated logic that compares the sign bits of the operands and the result to accurately detect and flag arithmetic overflows with an LED.

- **Hardware Display Interface**: The 8-bit result is split into its upper and lower 4-bit nibbles, with each half being sent to a dedicated display module to drive a 7-segment display.

---

## How It Works

The calculator's architecture is centered around a main processing module (`calcprocessing`) that coordinates the other components.

### Operand Storage

Two 8-bit registers store the operands, X and Y. For this implementation, the values were hardcoded to X=6 and Y=5.

### Operation Selection

The `calcprocessing` module receives the two operands and a 4-bit opcode. It uses a `case` statement to interpret the opcode and select the correct operation.

### Arithmetic Execution

All arithmetic is performed by a central `adder8` component. For subtraction (Y - X), the value of X is first inverted and then added to Y with a carry-in of `'1'` to complete the two's complement operation.

### Output and Display

The final 8-bit result is sent to the top-level output and is also split into two 4-bit values to be driven by two separate 7-segment display components.

---

## Code Snippet: Opcode Control Logic

The `case` statement from the main processing unit shows how a 4-bit opcode is used to select the active operation and calculate the result and overflow status.

```vhdl
-- Process to Select the Correct Output
process (X, Y, opcode, temp_result_add, temp_result_sub, temp_result_dec)
begin
    case opcode is
        when "0011" =>  -- X + Y
            result <= temp_result_add;
            overflow <= (X(7) and Y(7) and not temp_result_add(7)) or
                        (not X(7) and not Y(7) and temp_result_add(7));

        when "1000" =>  -- Y - X (Y + (-X))
            result <= temp_result_sub;
            overflow <= (Y(7) and not X(7) and not temp_result_sub(7)) or
                        (not Y(7) and X(7) and temp_result_sub(7));

        when "1001" =>  -- Y - 1 (Y + (-1))
            result <= temp_result_dec;
            -- Overflow logic can be added here if needed

        when others =>
            result <= (others => '0');
            overflow <= '0';
    end case;
end process;
```

---

## Technologies Used

- **Language**: VHDL
- **Software**: ModelSim, Quartus Prime
- **Hardware**: DE1-SoC Board
- **Core Concepts**: Signed Arithmetic, Two's Complement, Overflow Detection, Modular Design, FSM Control Logic, Hardware Interfacing

---

## Getting Started

### Prerequisites

- Quartus Prime software for compiling the VHDL code
- A DE1-SoC FPGA board for hardware implementation

### Installation & Execution

1. **Clone the Repository**: Download or clone the project files.
2. **Open in Quartus**: Open the Quartus project file (`.qpf`).
3. **Compile the Design**: Run the compilation process in Quartus to synthesize the design and generate a `.sof` (SRAM Object File).
4. **Program the FPGA**: Use the Quartus Programmer to upload the generated `.sof` file to the DE1-SoC board.
5. **Test the Calculator**: Use the onboard switches to provide the opcode and observe the results on the 7-segment displays and overflow LED.

