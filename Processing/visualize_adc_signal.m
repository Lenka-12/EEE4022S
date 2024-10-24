function visualize_adc_signal(adc_data, fs, plot_title)
    % Visualize ADC signal without reconstruction
    % Inputs:
    %   adc_data: Raw ADC data vector
    %   fs: Sampling frequency in Hz
    %   plot_title: Custom title for the plot (string)
    
    % Calculate THD using 10 harmonics
    thd_db = thd(adc_data, fs, 10);
    
    % Original time points
    t_original = (0:length(adc_data)-1)/fs;
    
    % Convert time to milliseconds for plotting
    t_original_ms = t_original * 1000;
    
    % Create figure with specific size for thesis
    figure('Position', [100, 100, 1000, 500]);
    
    % Blue color for the line plot
    line_color = [0 0 1];  % Blue
    
    % Plot original samples as a line plot
    plot(t_original_ms, adc_data, '-', 'Color', line_color, ...
         'LineWidth', 1.2, 'DisplayName', 'Audio Data');
    
    % Enhance plot appearance
    grid on;
    box on;
    legend('show', 'Location', 'northeast', 'FontSize', 10);
    
    % Labels and title
    xlabel('Time (ms)', 'FontSize', 12, 'FontWeight', 'bold');
    ylabel('Amplitude', 'FontSize', 12, 'FontWeight', 'bold');
    title(plot_title, 'FontSize', 14, 'FontWeight', 'bold');
    
    % Add THD value in a neat text box
    dim = [0.15 0.7 0.3 0.2];
    metrics_str = sprintf('THD = %.1f dB', thd_db);
    annotation('textbox', dim, 'String', metrics_str, ...
               'FitBoxToText', 'on', ...
               'BackgroundColor', [0.95 0.95 0.95], ...
               'EdgeColor', [0.3 0.3 0.3], ...
               'FaceAlpha', 0.8, ...
               'FontSize', 11, ...
               'FontWeight', 'bold');
    
    % Set axis limits based on data range
    ylim([min(adc_data)*1.1, max(adc_data)*1.1]);
    
    % Make plot publication-ready
    set(gcf, 'Color', 'white');
    set(gca, 'LineWidth', 1.2);
    set(findall(gcf,'-property','FontName'), 'FontName', 'Arial');
    
    % Adjust axes properties for better readability
    ax = gca;
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    ax.GridAlpha = 0.15;
    ax.LineWidth = 1.2;
    
    % Optional: Uncomment to save the figure
    % saveas(gcf, sprintf('%s.png', strrep(plot_title, ' ', '_')), 'png');
    % print('-dpdf', sprintf('%s.pdf', strrep(plot_title, ' ', '_')), '-bestfit');
end
