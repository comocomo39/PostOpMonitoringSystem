# PostOpMonitoringSystem

**PostOpMonitoringSystem** is a Verilog-based FPGA project designed to monitor a patient's condition during the post-operative phase. The system, implemented on a Basys3 board using Vivado 2020.2, simulates real-time monitoring of a drainage bag level with alarm management and historical logging.

## Features

- **5 Monitoring Stages**: Different alarm thresholds and behaviors for each stage.
- **User Interaction**: Input via board buttons and switches to simulate doctor actions.
- **Alarm Handling**: Visual alarms triggered when thresholds are exceeded.
- **History Logging**: Displays previous bag levels and system states upon request.
- **Automatic Events**: Bag change and stage progression every simulated 24 hours.
- **UART Output**: Real-time messages printed to a serial screen interface.
- **7-Segment Display**: Shows system state and bag levels.

## Main Components

- `SystemCore`: Central controller managing FSMs, timers, alarms, and level tracking.
- `Doctor`: Handles user inputs (buttons/switches).
- `Dispatcher`: Coordinates UART and SPI communication.
- `FSMs`: Multiple finite state machines for alarm logic, SPI timing, stage handling, and output messaging.
- `Display7Segmenti`: Manages messages on the 7-segment display.
- `TopModule`: Connects and integrates all subsystems.

## Usage

To use this project:
1. Open in **Vivado 2020.2**.
2. Target a **Basys3 board**.
3. Load the bitstream and observe outputs via 7-segment display and UART terminal.
4. Use the buttons and switches as defined in the documentation.

## Documentation

See [`Documentation.pdf`](Documentation.pdf) for detailed module descriptions, FSM diagrams, testbenches, and simulation results.

## Authors

- Andrea Carboni  
- Matteo Comini 

