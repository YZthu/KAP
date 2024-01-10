clear all;
close all;
clc;

% KAA dataset
data_path = 'KAA_csv/';
dataset_key = 'KAA';
labels = ["R1", "NA", "M1"];

% no KAA dataset
%{
data_path = 'no_KAA_csv/';
dataset_key = 'no_KAA';
labels = ["B1", "B2", "B3"]
%}
for bottle= labels
    for location = ["topright", "topleft", "middle", "bottomright", "bottomleft"]
        keyword = [char(bottle), '_', char(location)];
        csv_name = [data_path, keyword, '.csv'];

        data = csvread(csv_name);
        % figure
        % plot(data)
        % continue;
        
        %remove the mean in raw data
        data = data - mean(data);

        % creating noise_data for event detection

        noise_index = [1,4001];
        % noise_index = [1, 2001];
        % noise_index = [59994,86001]; % pillbottle
        start_index = noise_index(1);
        end_index = noise_index(2);
        noise_data = data(start_index:end_index);
        noise_data = noise_data - mean(noise_data);
        % figure;
        % plot(noise_data);

        % event detection
        Event_detection(data, noise_data, keyword, dataset_key)
        % event detection and fft featuer extraction
        Event_detection_and_fft_extraction(data, noise_data, keyword, dataset_key)
        
    end
end
