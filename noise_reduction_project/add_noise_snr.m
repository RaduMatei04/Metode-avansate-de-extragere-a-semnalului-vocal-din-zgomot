function y = add_noise_snr(x, n, targetSNR)
    % Calculeaza puterea semnalului curat
    Px = mean(x.^2);

    % Calculeaza puterea zgomotului
    Pn = mean(n.^2);

    % Scaleaza zgomotul pentru SNR-ul dorit
    scale = sqrt(Px / (Pn * 10^(targetSNR / 10)));
    n_scaled = scale * n;

    % Adauga zgomotul peste semnal
    y = x + n_scaled;

    % Normalizeaza daca apare clipping
    maxVal = max(abs(y));
    if maxVal > 1
        y = y / maxVal;
    end
end