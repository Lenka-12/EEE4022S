close all; clear; clc;
filename = '..\Python\signal_mixed\left.txt';
%filename = '..\slot1_data.txt';
len = 2048;
Fs = 48e3;
bit_depth = 24;
offset = 0;
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
        data(i) = str2double(line)-offset;
    else
        error('Unexpected end of file or reading error.');
    end
end
fclose(fileID);
plotFFTResults(data, Fs, "PCM1808 Data");
visualize_adc_signal(data, Fs, "PCM1808 Data");
data = data / max(data);
% % Compute THD
% thd_dB = thd(data, Fs,10);
% disp(thd_dB);
% thd_percent = 100 * 10^(thd_dB / 20);
% disp(['THD: ', num2str(thd_percent), ' %']);
% 
% 
% % Compute the FFT
% N = length(data);
% Y = fft(data);
% Y_shift = fftshift(Y);
% magnitudeY = abs(Y_shift);
% f = (-N/2:N/2-1)*(Fs/N); % frequency
% 
% % Plot the FFT
% figure;
% plot(f, magnitudeY./max(magnitudeY));
% title('FFT of the Signal');
% xlabel('Frequency (Hz)');
% ylabel('Magnitude');
% hold on;
% 
% 
% 
% % Time vector
% t = 0:1/Fs:length(data)/Fs-1/Fs;
% 
% % Reconstruct using linear interpolation
% reconstructed_signal = interp1(t, data, linspace(t(1), t(end), 10*length(t)));
% 
% % Plot the original ADC data and reconstructed signal
% figure;
% plot(t, data, 'o', linspace(t(1), t(end), 10*length(t)), reconstructed_signal);
% xlabel('Time (s)');
% ylabel('Amplitude');
% legend('ADC Output', 'Reconstructed Signal');
% title('PCM1808 Left Channel')
% %stem(data_norm(1:256))
% disp(snr(reconstructed_signal));
