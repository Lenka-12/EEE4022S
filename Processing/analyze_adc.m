function [snr_db, thd_db, sfdr_db, sinad_db] = analyze_adc(adc_data, fs, adc_bits)
    % Calculate ADC performance metrics from time domain data
    % Inputs:
    %   adc_data - Raw ADC samples
    %   fs - Sampling frequency in Hz
    %   adc_bits - ADC resolution in bits
    % Outputs:
    %   snr_db - Signal to Noise Ratio in dB
    %   thd_db - Total Harmonic Distortion in dB
    %   sfdr_db - Spurious Free Dynamic Range in dB
    %   sinad_db - Signal to Noise and Distortion in dB
    
    % Calculate FFT
    N = length(adc_data);
    fft_data = fft(adc_data);
    
    % Create power half-FFT (up to Nyquist)
    power_fft = zeros(1, floor(N/2));
    for i = 1:length(power_fft)
        power_fft(i) = sqrt(real(fft_data(i))^2 + imag(fft_data(i))^2) / (2^(2*adc_bits));
    end
    
    % Remove DC bin
    power_fft(1) = min(power_fft(2:end));
    
    % Find fundamental frequency bin (strongest peak excluding DC)
    [~, fundamental_bin] = max(power_fft(2:end));
    fundamental_bin = fundamental_bin + 1;  % Adjust for excluded DC bin
    fundamental_power = power_fft(fundamental_bin);
    
    % Print fundamental frequency
    fund_freq = (fundamental_bin-1) * fs / N;
    fprintf('Detected fundamental frequency: %.2f Hz\n', fund_freq);
    
    % Calculate SFDR
    temp_fft = power_fft;
    temp_fft(fundamental_bin) = 0;
    max_spur_power = max(temp_fft);
    sfdr_db = 10 * log10(fundamental_power / max_spur_power);
    
    % Calculate SINAD
    sinad_mask = true(1, length(power_fft));
    sinad_mask(1:2) = false;  % Remove DC area
    sinad_mask(end-1:end) = false;  % Remove Nyquist area
    % Remove area around fundamental
    fund_range = max(1, fundamental_bin-3):min(length(power_fft), fundamental_bin+3);
    sinad_mask(fund_range) = false;
    
    sinad_power = sum(power_fft(sinad_mask));
    sinad_db = 10 * log10(fundamental_power / sinad_power);
    
    % Calculate THD
    harm_power = 0;
    num_harmonics = 10;  % Consider harmonics 2 through 11
    harmonic_bins = zeros(1, num_harmonics);  % Store for plotting
    
    for h = 2:(num_harmonics+1)
        % Find harmonic bin
        bin_number = mod(h * (fundamental_bin-1), N);
        fold_count = floor((h * (fundamental_bin-1)) / N);
        
        if mod(fold_count, 2) == 0
            harmonic_bin = bin_number + 1;
        else
            harmonic_bin = N - bin_number + 1;
        end
        
        % If harmonic is within Nyquist limit
        if harmonic_bin <= length(power_fft)
            harm_power = harm_power + power_fft(harmonic_bin);
            harmonic_bins(h-1) = harmonic_bin;
        end
    end
    
    thd_db = 10 * log10(harm_power / fundamental_power);
    
    % Calculate SNR
    noise_power = sinad_power - harm_power;
    snr_db = 10 * log10(fundamental_power / noise_power);
    
    % Plot spectrum with annotations
    figure;
    freq_axis = (0:length(power_fft)-1) * fs / N;
    plot(freq_axis, 20*log10(power_fft));
    hold on;
    
    % Plot fundamental
    plot(freq_axis(fundamental_bin), 20*log10(power_fft(fundamental_bin)), 'ro', ...
         'DisplayName', 'Fundamental');
    
    % Plot harmonics
    for i = 1:length(harmonic_bins)
        if harmonic_bins(i) > 0 && harmonic_bins(i) <= length(power_fft)
            plot(freq_axis(harmonic_bins(i)), ...
                 20*log10(power_fft(harmonic_bins(i))), 'gx', ...
                 'DisplayName', sprintf('H%d', i+1));
        end
    end
    
    xlabel('Frequency (Hz)');
    ylabel('Power (dB)');
    title(sprintf('ADC Spectrum Analysis\nSNR: %.1fdB, THD: %.1fdB, SFDR: %.1fdB, SINAD: %.1fdB', ...
          snr_db, thd_db, sfdr_db, sinad_db));
    grid on;
    legend('show');
    
    % Print summary
    fprintf('\nADC Performance Metrics:\n');
    fprintf('SNR:   %.1f dB\n', snr_db);
    fprintf('THD:   %.1f dB\n', thd_db);
    fprintf('SFDR:  %.1f dB\n', sfdr_db);
    fprintf('SINAD: %.1f dB\n', sinad_db);
end