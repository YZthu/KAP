%SEDetection_geo.m

function [ stepEventsSig, stepEventsIdx, stepEventsVal, ...
            stepStartIdxArray, stepStopIdxArray, ... 
            windowEnergyArray, noiseMu, noiseSigma, noiseRange,sigEnergypeak ] = SEDetection_geo( rawSig, noiseSig, th, windowSize )

    % this function extract the events from a signal segment
    
    % windowSize = 200;
    WIN1=20;
    WIN2=20;
    offSet = 20;
    eventSize = 50;
    sigmaSize = th;
    geo_event_size = 0.02*length(rawSig)/60;
    
    states = 0;

    %using energy to compute
    windowEnergyArray = [];
    windowDataEnergyArray = [];
    stepEventsSig = {};
    stepEventsIdx = [];
    stepEventsVal = [];
    noiseRange = [];
    stepPeak = 1;
    stepStartIdxArray = [];
    stepStopIdxArray = [];
    sigEnergypeak = [];
    
    idx = 1;
    while idx < length(noiseSig) - max(windowSize, eventSize) - 10
         windowData = noiseSig(idx:idx+windowSize-1);
         windowDataEnergy = sum(windowData.*windowData);
         windowDataEnergyArray = [windowDataEnergyArray windowDataEnergy];
         idx = idx + offSet; 
    end
    
    [noiseMu,noiseSigma] = normfit(windowDataEnergyArray);

    idx = 1;
    windowEnergyArray = [];
    signal = rawSig;
    
    while idx < length(signal) - 2 * max(windowSize, eventSize)
        % if one sensor detected, we count all sensor detected it
        windowData = signal(idx:idx+windowSize-1);
        windowDataEnergy = sum(windowData.*windowData);
        windowEnergyArray = [windowEnergyArray; windowDataEnergy idx];
        
        % gaussian fit
        if abs(windowDataEnergy - noiseMu) < noiseSigma * sigmaSize

            if states == 1 && idx < length(signal) - eventSize
                % find the event peak as well as the event
                stepEnd = idx;
                stepRange = rawSig(stepStart:stepEnd);
                [localPeakValue, localPeak] = max(abs(stepRange));
                stepPeak = stepStart + localPeak - 1;
                % extract clear signal
                stepStartIdx = stepStart+ round(windowSize/2);%+ windowSize;%max(stepPeak - WIN1, stepStart);
                stepStopIdx = idx + round(windowSize/2);%stepStartIdx + eventSize - 1;
                if stepStopIdx - stepStartIdx > geo_event_size

                    stepSig = rawSig(stepStartIdx:stepStopIdx);
                    stepStartIdxArray = [stepStartIdxArray, stepStartIdx];
                    stepStopIdxArray = [stepStopIdxArray, stepStopIdx];
                    %energy peak
                    peak_ind =  find(((windowEnergyArray(:, 2) > stepStartIdx) & (windowEnergyArray(:, 2) < stepStopIdx)) == 1);
                    peak_ene = max(windowEnergyArray(peak_ind, 1));
                    sigEnergypeak = [sigEnergypeak, peak_ene];
                    % save the signal
                    if size(stepSig,2) == 1
                        stepEventsSig = [stepEventsSig; {stepSig'}];
                    else
                        stepEventsSig = [stepEventsSig; {stepSig}];
                    end
                    stepEventsIdx = [stepEventsIdx; stepPeak];
                    stepEventsVal = [stepEventsVal; localPeakValue];

                    % move the index to skip the event
                    idx = stepStopIdx - offSet;
                end
            end
            states = 0;
        else
            % mark step
            if states == 0 && idx - stepPeak > WIN1
                stepStart = idx; 
                states = 1;
            end
        end  
        idx = idx + offSet;
    end
    %{
    figure;
    plot(windowEnergyArray(:, 1)- noiseMu);
    hold on
    plot([1, length(windowEnergyArray(:, 1))], [noiseSigma * sigmaSize, noiseSigma * sigmaSize]);
    %}
    % title(num2str(length(stepEventsSig)));

    return
    % unfinished 
    if states == 1
        stepEnd = length(signal);
        stepRange = rawSig(stepStart:stepEnd);
        [localPeakValue, localPeak] = max(abs(stepRange));
        stepPeak = stepStart + localPeak - 1;


        % extract clear signal
        stepStartIdx = max(stepPeak - WIN1, stepStart);
        stepStopIdx = stepStartIdx + eventSize - 1;
        stepSig = rawSig(stepStartIdx:stepStopIdx);
        stepStartIdxArray = [stepStartIdxArray, stepStartIdx];
        stepStopIdxArray = [stepStopIdxArray, stepStopIdx];

        % save the signal
        if size(stepSig,2) == 1
            stepEventsSig = [stepEventsSig; stepSig'];
        else
            stepEventsSig = [stepEventsSig; stepSig];
        end
        stepEventsIdx = [stepEventsIdx; stepPeak];
        stepEventsVal = [stepEventsVal; localPeakValue];

    end
end