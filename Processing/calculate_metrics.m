function [SNR, THD, SFDR, SINAD, fundamental_freq] = calculate_metrics(signal, fs, ADCBits)
    % Inputs:
    % signal - Input signal
    % fs - Sampling frequency
    % ADCBits - Number of ADC bits

    % Parameters
    N = length(signal); % Length of the signal
    
    % Perform FFT and shift
    fft_result = fft(signal); % Compute the FFT
    fft_result = fftshift(fft_result); % Shift zero frequency component to the center

    % Calculate the power spectrum
    Power = abs(fft_result).^2 / N; % Normalize by the number of points
    half_fft = Power(N/2+1:end); % Use only the second half of FFT for positive frequencies

    % Step 1: Calculate power for positive half-FFT
    PowerHalfFFT = half_fft / (2^(2 * ADCBits)); % Normalize by ADC resolution

    % Step 2: Find the fundamental frequency bin accurately
    [~, fundamental_bin] = max(PowerHalfFFT); % Locate the maximum power bin
    FundamentalPower = PowerHalfFFT(fundamental_bin); % Power of the fundamental frequency

    % Calculate the actual fundamental frequency
    fundamental_freq = (fundamental_bin - 1) * fs / N; % Convert bin number to frequency

    % Step 3: Calculate SFDR
    % Exclude the fundamental bin for maximum spur power
    MaxSpurPower = max(PowerHalfFFT([1:fundamental_bin-1, fundamental_bin+1:end]));
    SFDR = 10 * log10(FundamentalPower / MaxSpurPower); % SFDR calculation

    % Step 4: Calculate SINAD
    total_power = sum(PowerHalfFFT); % Total power in the signal
    SINAD_Power = total_power - FundamentalPower; % Power of all components except the fundamental
    SINAD = 10 * log10(FundamentalPower / SINAD_Power); % SINAD calculation

    % Step 5: Calculate THD
    % Identify harmonic bins, assuming up to the 10th harmonic
    HarmonicBins = fundamental_bin * (2:11); % Consider harmonics from 2nd to 10th
    HarmonicBins(HarmonicBins > length(PowerHalfFFT)) = []; % Exclude harmonics beyond Nyquist
    HarmonicPower = sum(PowerHalfFFT(HarmonicBins)); % Sum the power of the harmonic bins
    THD = 10 * log10(HarmonicPower / FundamentalPower); % THD calculation

    % Step 6: Calculate SNR
    Noise_Power = SINAD_Power - HarmonicPower; % Power of the noise
    SNR = 10 * log10(FundamentalPower / Noise_Power); % SNR calculation
end
