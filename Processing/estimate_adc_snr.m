function snr_db = estimate_adc_snr(adc_data, fs)
    % Simple SNR estimation for ADC data
    % Input: 
    %   adc_data - Raw ADC samples
    %   fs - Sampling frequency in Hz
    % Output:
    %   snr_db - SNR in dB
    
    % 1. Remove DC offset
    data = adc_data - mean(adc_data);
    N = length(data);
    
    % 2. Get frequency spectrum
    spectrum = abs(fft(data))/N;
    spectrum = spectrum(1:N/2+1);  % Single-sided spectrum
    
    % 3. Find main signal peak
    [peak_val, peak_idx] = max(spectrum);
    
    % 4. Create simple signal and noise masks
    signal_mask = false(size(spectrum));
    % Include main peak and adjacent bins
    peak_width = 3;  % Adjust based on your needs
    start_idx = max(1, peak_idx - peak_width);
    end_idx = min(length(spectrum), peak_idx + peak_width);
    signal_mask(start_idx:end_idx) = true;
    
    % 5. Calculate powers
    signal_power = sum(spectrum(signal_mask).^2);
    noise_power = sum(spectrum(~signal_mask).^2);
    
    % 6. Calculate SNR
    snr_db = 10 * log10(signal_power/noise_power);
    
    % Optional: Plot for visualization
    freq = (0:N/2)* fs/N;
    figure;
    plot(freq, 20*log10(spectrum));
    hold on;
    plot(freq(signal_mask), 20*log10(spectrum(signal_mask)), 'r.');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    title(['Estimated SNR: ' num2str(snr_db, '%.1f') ' dB']);
    grid on;
end