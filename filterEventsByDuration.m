function [filteredStart, filteredStop] = filterEventsByDuration(startIdx, stopIdx, minDuration)
    durations = stopIdx - startIdx;
    validIdx = find(durations >= minDuration);
    filteredStart = startIdx(validIdx);
    filteredStop = stopIdx(validIdx);
end