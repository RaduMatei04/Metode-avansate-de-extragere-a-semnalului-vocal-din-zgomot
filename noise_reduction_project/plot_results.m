function plot_results(x, y, y_denoised, fs, snr_level)

    tx = (0:length(x)-1) / fs;
    ty = (0:length(y)-1) / fs;
    td = (0:length(y_denoised)-1) / fs;

    % Semnale in timp
    figure('Name', sprintf('Rezultate timp - %d dB', snr_level));

    subplot(3,1,1);
    plot(tx, x);
    title('Semnal curat');
    xlabel('Timp [s]');
    ylabel('Amplitudine');
    grid on;

    subplot(3,1,2);
    plot(ty, y);
    title(sprintf('Semnal zgomotos (%d dB)', snr_level));
    xlabel('Timp [s]');
    ylabel('Amplitudine');
    grid on;

    subplot(3,1,3);
    plot(td, y_denoised);
    title('Semnal dupa denoising');
    xlabel('Timp [s]');
    ylabel('Amplitudine');
    grid on;

    % Spectrograme
    figure('Name', sprintf('Spectrograme - %d dB', snr_level));

    subplot(3,1,1);
    spectrogram(x, hamming(512), 256, 512, fs, 'yaxis');
    title('Spectrograma - semnal curat');

    subplot(3,1,2);
    spectrogram(y, hamming(512), 256, 512, fs, 'yaxis');
    title(sprintf('Spectrograma - semnal zgomotos (%d dB)', snr_level));

    subplot(3,1,3);
    spectrogram(y_denoised, hamming(512), 256, 512, fs, 'yaxis');
    title('Spectrograma - semnal dupa denoising');
end