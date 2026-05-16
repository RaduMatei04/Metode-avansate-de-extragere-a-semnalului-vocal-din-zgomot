function x = istft_custom(S, frameLen, hop, win)

    numFrames = size(S, 2);
    xLen = (numFrames - 1) * hop + frameLen;

    x = zeros(xLen, 1);
    wsum = zeros(xLen, 1);

    for k = 1:numFrames
        frame = real(ifft(S(:, k), frameLen));
        idx = (k - 1) * hop + (1:frameLen);

        x(idx) = x(idx) + frame .* win;
        wsum(idx) = wsum(idx) + win.^2;
    end

    nz = wsum > 1e-10;
    x(nz) = x(nz) ./ wsum(nz);
end