close all; clear; clc;
filename = '..\Python\signal_mixed\left.txt';
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
