function y_out = spectral_subtraction(y, fs)

    % Parametri STFT
    frameLen = 512;
    hop = 256;
    win = hamming(frameLen, 'periodic');

    % Estimare zgomot din primele 0.5 secunde
    noise_samples = min(round(0.5 * fs), length(y));
    noise_part = y(1:noise_samples);

    % Spectrul zgomotului
    [S_noise, ~, ~] = spectrogram(noise_part, win, frameLen - hop, frameLen, fs);
    noise_mag = mean(abs(S_noise), 2);

    % Spectrul semnalului zgomotos
    [S, ~, ~] = spectrogram(y, win, frameLen - hop, frameLen, fs);
    mag = abs(S);
    phase = angle(S);

    % Spectral subtraction
    alpha = 1.0;
    mag_clean = mag - alpha * noise_mag;

    % Evita valori negative
    mag_clean = max(mag_clean, 0.02 * mag);

    % Reconstruieste spectrul complex
    S_clean = mag_clean .* exp(1j * phase);

    % Reconstruieste semnalul in timp
    y_out = istft_custom(S_clean, frameLen, hop, win);
    y_out = y_out(:);

    % Ajustare lungime la original
    if length(y_out) > length(y)
        y_out = y_out(1:length(y));
    elseif length(y_out) < length(y)
        y_out(end+1:length(y)) = 0;
    end

    % Normalizare finala
    maxVal = max(abs(y_out));
    if maxVal > 1
        y_out = y_out / maxVal;
    end
end