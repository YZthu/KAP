function fft_results = performFFT(signal, startIndex, endIndex, FS)
    event_signal = signal(startIndex:endIndex);
    normalized_signal = event_signal ./ sqrt(sum(event_signal.^2));
    fft_result = abs(fft(normalized_signal, FS));
    fft_results = fft_result(1:round(FS/2));  % Keep only positive frequencies
end