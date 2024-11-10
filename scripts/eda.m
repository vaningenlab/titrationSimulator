% prepareNMR.m
% 
% sets acquisition parameters
% 

%clc
promptForReEnter = 0;
disp("")
if questionAsked(3) == 0 && easyMode < 2
    question(3)     % question on length of INEPT or on NH2 appearance
end
if titrationPoint == 1
    % first time that eda is used
    disp("")
    disp("Hit enter to use default values")
    disp("")
    if easyMode < 2
        atHi = input("Enter the 1H acquisition time (in sec, default 0.08): ","s");
        atNi = input("Enter the 15N acquisition time (in sec, default 0.04): ","s");
    else
        atHi = "0.08";
        atNi = "0.04"; % 0.025 for testing
    end
    nsi  = input("Enter the number of scans (ns) (8, 16, 24, .., default 8): ", "s");
else
    % changing the current numbers, can only change ns!
    disp("")
    disp("Current values are:")
    printf("    1H acquisition time %5.3f sec\n", atH)
    printf("   15N acquisition time %5.3f sec\n", atN)
    printf("   number of scans (ns) %d\n", ns)
    disp("")
    disp("Since you already started the titration experiment, you can only change ns.")
    disp("Hit enter to keep the current value")
    disp("")
    nsi  = input("Enter the number of scans (ns) (8, 16, 24, .., default 8): ", "s");
end
% check input validity
if length(regexp(atHi,'[.\d]')) < length(atHi)
    promptForReEnter = 1
end
if length(regexp(atNi,'[.\d]')) < length(atNi)
    promptForReEnter = 1
end
if length(regexp(nsi,'[.\d]')) < length(nsi) 
    promptForReEnter = 1
end
if  promptForReEnter == 1
    disp("")
    disp("Please enter a positive number without units!")
    disp("Type \"eda\" again to re-enter your values")
    disp("")
else
    % valid input
    if titrationPoint == 1
        % first time, if enter then default
        if length(atHi) == 0
            atH = 0.08;
        else
            atH = str2num(atHi);
        end
        if length(atNi) == 0
            atN = 0.04;
        else
            atN = str2num(atNi);
        end
        if length(nsi) == 0
            ns = 8;
        else
            ns = str2num(nsi);
        end
    else
        % if not the first time, enter is keep current, so nothing to do
        if length(nsi) > 0
            ns = str2num(nsi);
        end
    end
    % now everything converted to valid number
    if mod(ns,8) > 0
        disp("")
        disp("Hmmm. The number of scans needs to be a multiple of 8 here.")
        disp("I'll reset to the nearest multiple.")
        junk=input("<>","s");
    end
    ns = 8*round(ns/8);   % make sure multiple of 8 scans is used
    % 120 ms acq. time in 1H as in real life as absolute max.
    if atH > 0.12
        disp("")
        disp("Oops! Don't fry the probe! Limit the 1H acquisition time to 120ms maximum.")
        disp("Type \"eda\" again at the command prompt and adjust your acq. times.")
        disp("")
    elseif atN > 0.1
        disp("")
        disp("Mmmm, with such long 15N acquisition time the experiment is going to take very long.")
        disp("Reduce the 15N acquisition time to 100ms maximum.")
        disp("Type \"eda\" again at the command prompt and adjust your acq. times.")
        disp("")
    elseif atH < 0.005
        disp("")
        printf("%.2f ms is really too short to record the FID in the 1H dimension. Adjust to 5ms minimum.\n", atH*1000)
        disp("Type \"eda\" again at the command prompt and adjust your acq. times.")
        disp("")
    elseif atN < 0.002
        disp("")
        printf("%.2f ms is really too short to record the FID in the 15N dimension. Adjust to 2ms minimum.\n", atN*1000)
        disp("Type \"eda\" again at the command prompt and adjust your acq. times.")
        disp("")
    elseif ns > 64
        disp("")
        disp("Wow, are really that patient? Reduce the number of scans to 64 maximum,")
        disp("otherwise you're stuck here till tomorrow!")
        disp("Type \"eda\" again at the command prompt and adjust ns")
        disp("")
     elseif ns == 0
        disp("")
        disp("Zero scans, are you kidding me ?!")
        disp("Type \"eda\" again at the command prompt and adjust ns")
        disp("")
    else
        if titrationPoint == 1
            % if doing eda second time, we're stuck to atN,atH
            dwtH = 1/swH;                   % dwell time                 
            npH  = round(atH/dwtH);      % number of points in 1H dim (320)
            if mod(npH,2) == 1
                npH = npH +1;
            end
            tH   = [0:dwtH:(npH-1)*dwtH];   % time vector
            dwtN = 1/swN;                   % dwell time
            npN  = round(atN/dwtN)+1;    % number of points in 15N dim (75) ? should be set by student ?
            if mod(npN,2) == 1
                npN = npN +1;
            end
            tN   = [0:dwtN:(npN-1)*dwtN];   % time vector
            % set size of spectrum
            zfH = 2^(round(log2(npH))+1);           % zerofill once
            zfN = 2^(round(log2(npN))+1);           % zerofill once
            % initialize container for all spectra
            allSpectra = zeros(zfN, zfH, 1);            % will be 3D matrix, containing 2D spectra for each titration point
            peakStoreX = zeros(npN, npH, numPeaks, 1);  % will be 4D matrix, containing 2D FIDs for each peak, for each titration point
            peakStoreY = zeros(npN, npH, numPeaks, 1);
        end
        disp("")
        disp("Everything is setup!")
        disp("")
        printf("\tThe number of scans for the 2D HSQC is %d.\n", ns)
        if easyMode == 3
            disp("\tThe 1H and 15N 90-degree pulses are set to their default values.")
        end
        if easyMode < 3
            printf("\tThe 1H 90-degree pulse (p1) is set to %.2f microseconds.\n", p1)
        end
        if easyMode < 2
            printf("\tThe 15N 90-degree pulse (p21) is set to default value of %.2f microseconds.\n", p21)
            printf("\tThe acquisition times are set to %d ms for 1H and %d ms for 15N.\n", atH*1000, atN*1000)
        end
        if titrationPoint == 1
            disp("")
            disp("Now start the experiment by typing \"zg\" at the command prompt")
            disp("")
        else
            disp("")
            disp("If you already added ligand to your sample, start the experiment by typing \"zg\" at the command prompt")
            disp("Otherwise, add ligand using \"titrate\" and then run the experiment")
            disp("")
        end
    end
end
