function plotFFTResults(data, Fs, title_s)
    % Input: data - array of 2048 bytes
    
    % Convert bytes to double if needed
    if ~isa(data, 'double')
        data = double(data);
    end
    
    % Compute FFT
    N = length(data);
    Y = fft(data);
    

    f = (0:N-1)*(Fs/N);
    f = f(1:N/2+1);  % Positive frequencies only
    
    % Compute magnitude
    magnitude = abs(Y(1:N/2+1));
    magnitude = magnitude/N;  % Normalize
    magnitude(2:end-1) = 2*magnitude(2:end-1);  % Adjust for single-sided spectrum
    magnitude_db = 20*log10(magnitude + eps);
    
    % Find peaks
    [peak_mags, peak_locs] = findpeaks(magnitude_db, ...
        'MinPeakDistance', 5);  % Minimum 5 samples between peaks
    
    % Get highest peak (excluding DC)
    [sorted_mags, sort_idx] = sort(peak_mags, 'descend');
    sorted_locs = peak_locs(sort_idx);
    sorted_freqs = f(sorted_locs);
    
    % Remove DC component (near-zero frequency)
    dc_threshold = 10; % Hz
    valid_peaks = sorted_freqs > dc_threshold;
    max_mag = sorted_mags(find(valid_peaks, 1, 'first'));
    max_freq = sorted_freqs(find(valid_peaks, 1, 'first'));
    
    % Create figure
    figure('Position', [100 100 1000 600]);
    
    % Plot full spectrum in blue
    plot(f, magnitude_db, 'Color', [0 0.4470 0.7410], 'LineWidth', 1.5);
    hold on;
    
    % Plot highest peak with red marker
    plot(max_freq, max_mag, 'ro', ...
        'MarkerSize', 10, ...
        'LineWidth', 2, ...
        'MarkerFaceColor', 'r');
    
    % Add annotation for the highest peak
    text(max_freq, max_mag + 3, ...
        sprintf('Peak: %.1f Hz\n%.1f dB', max_freq, max_mag), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 10);
    
    % Add vertical dashed line at peak
    line([max_freq max_freq], ...
        [min(magnitude_db) max_mag], ...
        'Color', 'r', ...
        'LineStyle', '--', ...
        'LineWidth', 1);
    
    % Formatting
    grid on;
    set(gca, 'XMinorGrid', 'on', 'YMinorGrid', 'on');
    xlabel('Frequency (Hz)', 'FontSize', 12);
    ylabel('Magnitude (dB)', 'FontSize', 12);
    title(title_s, 'FontSize', 14);
    
    % Set axis limits
    xlim([0 Fs/2]);
    ylim([max(min(magnitude_db), -100) max(magnitude_db) + 10]);
    
    % Figure formatting
    set(gcf, 'Color', 'white');
    set(gca, 'FontName', 'Arial');
    set(gca, 'Box', 'off');
    set(gca, 'TickDir', 'out');
    set(gca, 'TickLength', [.02 .02]);
    
    % Print result to command window
    fprintf('\nHighest Frequency Component:\n');
    fprintf('-------------------------\n');
    fprintf('Frequency: %.1f Hz\n', max_freq);
    fprintf('Magnitude: %.1f dB\n', max_mag);
end

% Example usage:
% data = your_2048_byte_array;
% plotFFTResults(data);
% 
% % Save figure
% saveas(gcf, 'fft_analysis.pdf', 'pdf')