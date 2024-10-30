# Audio Digitisation System 🎵

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A high-performance audio digitization system built around the STM32F7 microcontroller, featuring dual Delta-Sigma ADCs (PCM1808 and ADAU1978) and an integrated ADC for comprehensive audio capture.

## 🎯 Overview

This project implements a complete audio digitization pipeline that captures audio data through multiple ADCs and transmits it to a PC for MATLAB-based analysis.

## 🔧 Hardware Components

### STM32F7 Nucleo Board
- Main processing unit
- Handles ADC interfacing and USB communication

### PCM1808 Delta-Sigma ADC ([Buy](https://www.aliexpress.com/item/32777376004.html))
- Stereo Audio ADC configuration
- Input: Bottom port MEMS microphone from DEVKIT-MEMS-001
- Signal conditioning via AD828 op-amp module ([AD828 Module Source](https://www.robotics.org.za/AD828A))
- I2S interface via SAI1 Block B
- 48 kHz sampling rate
- DMA circular mode operation

### Integrated ADC
- Input: Nucleo board pin A3
- Signal from top port MEMS microphone (DEVKIT-MEMS-001)
- Signal conditioning via BOB-09816 ([SparkFun BOB-09816](https://www.sparkfun.com/products/9816))
- Timer-triggered operation
- Circular DMA mode

### ADAU1978 Delta-Sigma ADC
- Integrated via [STEVAL-STWINMAV1](https://www.st.com/en/evaluation-tools/steval-stwinmav1.html) module
- TDM4 protocol through SAI1 Block A
- 24-bit resolution at 48 kHz
- DMA circular mode operation

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

## 🛠️ Hardware Sources

### Microphones
- [DEVKIT-MEMS-001](https://www.sparkfun.com/products/9816)
  - Bottom port MEMS mic → PCM1808
  - Top port MEMS mic → Integrated ADC

### Signal Conditioning
- PCM1808: [AD828 Op-amp Module](https://www.robotics.org.za/AD828A)
- Integrated ADC: [BOB-09816](https://www.sparkfun.com/products/9816)

### ADC Modules
- [PCM1808 Stereo Delta-Sigma ADC](https://www.aliexpress.com/item/32777376004.html)
- [STEVAL-STWINMAV1](https://www.st.com/en/evaluation-tools/steval-stwinmav1.html) (ADAU1978)
- STM32F7 Integrated ADC

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
- SparkFun Electronics for DEVKIT-MEMS-001 and BOB-09816
- Contributors and testers

---
*For technical questions and support, please open an issue in the repository.*
