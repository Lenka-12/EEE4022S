% Specify the file path of the .wav file
close all; clc; clear;
file_path = 'signal0_1.wav';  % Replace 'example.wav' with your .wav file's name

% Read the .wav file
[audio_data, fs] = audioread(file_path);

plotFFTResults(audio_data, fs, "Original Audio");
visualize_adc_signal(audio_data,fs, "Original Audio");