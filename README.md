# Audio Digitisation System 🎵

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A high-performance audio digitization system built around the STM32F7 microcontroller, featuring dual ADC integration with the PCM1808 and ADAU1978.

## 🎯 Overview

This project implements a complete audio digitization pipeline that captures audio data through multiple ADCs and transmits it to a PC for MATLAB-based analysis.

## 🔧 Hardware Components

### STM32F7 Nucleo Board
- Main processing unit
- Handles ADC interfacing and USB communication

### PCM1808 Audio ADC
- Driven by AD828 op-amp module
- I2S interface via SAI1 Block B
- 48 kHz sampling rate
- DMA circular mode operation

### ADAU1978 Audio ADC
- Integrated via STEVAL-STWINMAV1 module
- TDM4 protocol through SAI1 Block A
- 24-bit resolution at 48 kHz
- DMA circular mode operation

> **Important Note**: When configuring SAI for TDM:
> - Clock strobing must be set to rising edge
> - Frame Synchro offset must be set before the First Bit

### Integrated ADC
- Input: Nucleo board pin A3
- Timer-triggered operation
- Circular DMA mode

## 🔌 Communication

### USB Interface
- Protocol: USB Full Speed (FS) CDC
- Data transmission triggered by user button
- ADC activation controlled via Python script commands

## 💡 Status Indicators

| LED  | Function |
|------|----------|
| LD1  | Integrated ADC active |
| LD2  | PCM1808 active |
| LD3  | ADAU1978 active |

## 📝 PCB Documentation

The repository includes:
- STEVAL-STWINMAV1 module adapter designs
- Audio Digitisation Hardware based on PCM1862 (production pending)

## 🚀 Getting Started

1. Clone the repository
```bash
git clone https://github.com/yourusername/audio-digitisation-system.git
```

2. Install dependencies (Python script requirements)
```bash
pip install -r requirements.txt
```

3. Connect the hardware components according to the pinout documentation

4. Flash the STM32F7 firmware

5. Run the Python control script to begin data acquisition

## 📊 Data Analysis

MATLAB scripts are provided for processing the captured audio data. See the `/matlab` directory for analysis tools.

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ✨ Acknowledgments

- STMicroelectronics for the STEVAL-STWINMAV1 reference design
- Contributors and testers

---
*For technical questions and support, please open an issue in the repository.*
