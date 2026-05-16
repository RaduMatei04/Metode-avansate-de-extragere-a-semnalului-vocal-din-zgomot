function snr_val = compute_snr(signal, noise)
    snr_val = 10 * log10(sum(signal.^2) / (sum(noise.^2) + eps));
end