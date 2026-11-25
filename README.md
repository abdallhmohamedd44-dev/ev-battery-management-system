# Smart Battery Management System for Electric Vehicles

Graduation project, B.Sc. Electrical Engineering (Power and Machines), Aswan University, 2024.
Team project by four students; supervisors Dr. Tarek Younis and Eng. Nader Mostafa.

This repository holds the simulation figures, prototype photos and MATLAB code from the thesis.

## Contents

### 1. EV battery charger (synchronous buck converter)
- Specification (scaled-down): 25 V input, 10 ohm load, 400 uH, 220 uF, 40 kHz switching, CCM.
- Cascaded average current-mode control: inner current loop and outer voltage loop, PI gains designed in MATLAB for a 60 degree phase margin.
- Constant-current / constant-voltage charging simulated on a 5.4 Ah Li-ion cell model, then built on a PCB (KiCad). Step responses captured on an oscilloscope.
- Code: `matlab/charger_pi_design.m`
- Figures: see [FIGURES.md](FIGURES.md) (bode plots, step responses, PCB, oscilloscope captures)

### 2. Battery model and SOC estimation
- Enhanced self-correcting equivalent-circuit cell model in Simulink, state of charge estimated with an Extended Kalman Filter.
- Code: `matlab/ekf_soc_estimator.m`
- Figures: see [FIGURES.md](FIGURES.md) (cell model and Simulink implementation)

### 3. Active cell balancing
- Inductor-based balancing for two series cells (28 uH, 20 kHz, 4 A peak) with SOC-driven switching logic.
- Simulated during charging and discharging, then built on a PCB.
- Code: `matlab/balancing_switching_logic.m`
- Figures: see [FIGURES.md](FIGURES.md) (balancing circuit, simulation results, PCB, prototype)

## Notes
- Figures are page renders from the thesis PDF, so captions are visible in each image.
- MATLAB files were transcribed from the thesis text; spacing may need small fixes before running.
