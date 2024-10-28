# Audio Digitisation System

## Overview
This project demonstrates an audio digitization system utilizing the **PCM1808** and **ADAU1978** ADCs connected to the **STM32F7** microcontroller. The system captures audio data and sends it to a PC for further analysis using MATLAB scripts.

## Components
- **STM32F7 Nucleo Board**
- **PCM1808 Audio ADC**
  - Driven by the **AD828** op-amp module.
  - Connected to **SAI1 Block B** over **I2S**.
  - Operates at **48 kHz** with **DMA circular mode**.
- **ADAU1978 Audio ADC**
  - Based on the **STEVAL-STWINMAV1** platform.
  - Connected via **TDM4**.
  - Operates at **24 bits**, **48 kHz**, with **DMA circular mode**.
- **Integrated ADC**
  - Input from **A3** on the Nucleo board.
  - Triggered by a timer in **circular DMA mode**.

## USB Communication
- Audio data is transmitted to the PC using **USB Full Speed (FS) CDC** upon pressing the user button.
- Each ADC is activated by messages received from a Python script.

## LED Indicators
- **LD1**: Integrated ADC active
- **LD2**: PCM1808 active
- **LD3**: ADAU1978 active

