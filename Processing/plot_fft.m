close all; clear; clc;
filename = '..\Python\right.txt';
len = 2048;
Fs = 48e3;
bit_depth = 16;
offset = 2048;

% Open the file
fileID = fopen(filename, 'r');
if fileID == -1
    error('Failed to open the file.');
end

% Preallocate an array to hold [len] numbers
data = zeros(1, len);
for i = 1:len
    line = fgets(fileID);
    if ischar(line)
        data(i) = str2double(line);
    else
        error('Unexpected end of file or reading error.');
    end
end

fclose(fileID);
data_norm = normalize_adc_samples(data);

% Compute THD
thd_dB = thd(data_norm, Fs, 10);
disp(thd_dB);
thd_percent = 100 * 10^(thd_dB / 20);
disp(['THD: ', num2str(thd_percent), ' %']);

% Compute the FFT
N = length(data_norm);
Y = fft(data_norm);
magnitudeY = abs(Y) / N; % Normalize the magnitude
f = (0:N-1) * (Fs/N); % frequency vector

% Only take the first half of the FFT output (real signals)
magnitudeY = magnitudeY(1:N/2); % Take only the positive frequencies
f = f(1:N/2); % Corresponding frequency vector for positive frequencies

% Plot the FFT
figure;
stem(f, magnitudeY, 'filled'); % Use stem plot for FFT bins
title('FFT of the Signal - Bins');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([0 Fs/2]); % Limit x-axis to Nyquist frequency
grid on; % Optional: Add a grid for better readability

% Plot first 256 samples of normalized data
% figure;
% %stem(data_norm(1:256));
% title('First 256 Samples of Normalized Data');
% xlabel('Sample Index');
% ylabel('Amplitude');

function normalized_samples = normalize_adc_samples(samples)
    % Find the minimum and maximum values
    min_value = min(samples);
    max_value = max(samples);
    disp(['Max Value: ', num2str(max_value)]);
    % Normalize samples to the range -1 to 1
    normalized_samples = (samples - min_value) / (max_value - min_value) * 2 - 1;
end
