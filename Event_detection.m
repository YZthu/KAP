
function Event_detection(signal_data, noise_data, varType, dataset_key)
    disp("I am working with : "+ varType);
    % Event Detection
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

    filteredEvents = cell(length(eventStartIdxArray), 1);
    for i = 1:length(eventStartIdxArray)

        event_data = signal_data(eventStartIdxArray(i):eventStopIdxArray(i));


        filteredEvents{i} = event_data;
    end

    folderName = ['Detected_Events/', dataset_key];

    save([folderName,'_', varType,'_Events.mat'], 'filteredEvents');

    % Save only FFT results to a CSV file in the specified folder
    % csvFileName = strcat(folderName, '_', varType, '_Events.csv');
    % fullFilePath = fullfile(folderName, csvFileName);
    % csvwrite(csvFileName, filteredEvents);

end







