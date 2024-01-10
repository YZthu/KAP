
function Event_detection_and_fft_extraction(signal_data, noise_data, varType, dataset_key)
   
  
    windowSize = 1500;

    % Define a minimum event duration
    min_event_duration = 1600;  

    % Check if varType contains specific substrings and set parameters accordingly
    %{
    if contains(varType, 'M1')
        threshold = 200;
    elseif contains(varType, 'M2')
        threshold = 300;
    elseif contains(varType, 'R1') || contains(varType, 'R2')
        threshold = 200;
    elseif contains(varType, 'NA')
        threshold = 200;
        min_event_duration = 1500;
    else
        error('Invalid varType provided.');
    end
    %}
    threshold = 200;

    [events, eventStartIndices, ~, eventStartIdxArray, eventStopIdxArray, ~, ~, ~, ~, ~] = SEDetection_geo(signal_data, noise_data, threshold, windowSize);
    [filteredStart, filteredStop] = filterEventsByDuration(eventStartIdxArray, eventStopIdxArray, min_event_duration);

    disp(length(filteredStart)+"tt:"+varType);
    % figure;
    % plot(signal_data); hold on;
    % scatter(eventStartIdxArray, signal_data(eventStartIdxArray), 'r', 'Marker', 'o'); % Display start points
    % scatter(eventStopIdxArray, signal_data(eventStopIdxArray), 'k', 'Marker', 'x');  % Display end points
    % hold off;
    % title([varType ' with Detected Events']);
    % 
    % figure;
    % plot(signal_data); hold on;
    % scatter(filteredStart, signal_data(filteredStart), 'g', 'Marker', 'o');
    % scatter(filteredStop, signal_data(filteredStop), 'm', 'Marker', 'x');
    % hold off;
    % title([varType ' with Filtered Events']);

    %Sampling rate for fft
    FS = 2350;
    
    % Perform FFT on the filtered events using performFFT
    fft_results = [];
    for i = 1:length(filteredStart)
        startIndex = filteredStart(i);
        endIndex = filteredStop(i);
        fft_result = performFFT(signal_data, startIndex, endIndex, FS);
        % figure;
        % plot(fft_result);
        % hold on

        % Assuming fft_result is a row vector; if it's a column vector, transpose it before appending.
        fft_results = [fft_results; fft_result'];
    end

    % % % Create the directory if it doesn't exist
    folderName = 'FFT_features';
    if ~exist(folderName, 'dir')
        mkdir(folderName);
    end

    % Save only FFT results to a CSV file in the specified folder
    csvFileName = strcat(dataset_key, '_', varType, '.csv');
    fullFilePath = fullfile(folderName, csvFileName);
    csvwrite(fullFilePath, fft_results);

    % folderName = 'FFT_Night/';
    % if ~exist(folderName, 'dir')
    %     mkdir(folderName);
    % end
    % 
    % save([folderName,varType,'fft_features.mat'], 'fft_results');
end




