% Parameters
close all; clc; clear;
samplingRate = 48000; % Sampling rate (48 kHz)
duration = 60; % Duration of the audio in seconds
frequency = 500; % Frequency of the sine wave
noiseLevel = 0.1; % Amplitude of the white noise

% Generate time vector
t = 0:1/samplingRate:duration; % Time vector from 0 to duration with 1/samplingRate step

% Generate a sine wave
sineWave = 0.5 * sin(2 * pi * frequency * t);

% Generate white noise
whiteNoise = noiseLevel * randn(size(sineWave)); % White noise

% Combine the sine wave with white noise
customSignal = sineWave + whiteNoise;

% Normalize the signal to prevent clipping
customSignal = customSignal / max(abs(customSignal));
disp(snr(customSignal))

% Save to a .wav file
audiowrite('signal_mixed_0_1.wav', customSignal, samplingRate);

% Optional: Plot the generated signal
figure;
plot(t(1:768), customSignal(1:768));
title('1 kHz Sine Wave with White Noise');
xlabel('Time (s)');
ylabel('Amplitude');
