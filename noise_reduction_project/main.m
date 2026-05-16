clear; clc; close all;

% Creeaza folder pentru rezultate daca nu exista
if ~exist('results', 'dir')
    mkdir('results');
end
if ~exist(fullfile('results','audio'), 'dir')
    mkdir(fullfile('results','audio'));
end

% Citire fisiere audio
[x, fs1] = audioread(fullfile('data', 'speech_clean.wav'));
[n, fs2] = audioread(fullfile('data', 'traffic_noise.wav'));

% Conversie la mono daca fisierele sunt stereo
if size(x, 2) > 1
    x = mean(x, 2);
end

if size(n, 2) > 1
    n = mean(n, 2);
end

% Resampling daca frecventele de esantionare difera
if fs2 ~= fs1
    n = resample(n, fs1, fs2);
end
fs = fs1;

% Ajustare lungime zgomot
if length(n) < length(x)
    reps = ceil(length(x) / length(n));
    n = repmat(n, reps, 1);
end
n = n(1:length(x));

% Normalizeaza usor semnalul curat
x = x / max(abs(x) + eps);

% Lista niveluri SNR pentru teste
snr_list = [10, 5, 0];

for k = 1:length(snr_list)
    targetSNR = snr_list(k);

    % Construieste semnalul zgomotos
    y = add_noise_snr(x, n, targetSNR);

    % Aplica denoising
    y_denoised = spectral_subtraction(y, fs);

    % Calculeaza SNR inainte si dupa
    snr_before = compute_snr(x, y - x);
    snr_after  = compute_snr(x, y_denoised - x);

    fprintf('\n=== Test pentru SNR initial = %d dB ===\n', targetSNR);
    fprintf('SNR inainte de denoising: %.2f dB\n', snr_before);
    fprintf('SNR dupa denoising: %.2f dB\n', snr_after);

    % Salveaza fisierele audio
    noisy_name = fullfile('results', 'audio', sprintf('speech_noisy_%ddB.wav', targetSNR));
    den_name   = fullfile('results', 'audio', sprintf('speech_denoised_%ddB.wav', targetSNR));

    audiowrite(noisy_name, y, fs);
    audiowrite(den_name, y_denoised, fs);

    % Plot rezultate
    plot_results(x, y, y_denoised, fs, targetSNR);
end