% plot2D.m
%

% S/N of 10 means startFloor at 0.1 should give just a bit of noise

tp=titrationPoint;

% determine baselevel - should not change during titration
% when startFloor is close to noise, then contouring is very slow!

if tp == 1
    % get maximum peak height
    peakHeight = max([max(max(Sr)) -min(min(Sr))]);
    % need accurate noise estimate in 2D spectrum, just calculate noise spectrum
    % get noiselevel as RMS of noise spectrum and store as global variable
    McXn  = noiseSf*noiseX;
    McYn  = noiseSf*noiseY;
    SpHXn = processFID(McXn, zfH, 0, 0, 0, 0, swH); # amplitude modulated cosine FID
    SpHYn = processFID(McYn, zfH, 0, 0, 0, 0, swH); # amplitude modulated sine FID
    Sn   = processFID(SpHXn + sqrt(-1)*SpHYn, zfN, 0, 0, 0, 0, swN);
    noiseLevel = sqrt(mean(mean(real(Sn).^2)));
    sino = peakHeight/noiseLevel;
    disp("")
    printf("Signal-to-noise ratio for the strongest peak is ~ %.1f\n", sino)
    % if very noisy should switch to dataview
    baseLevel=startFloor*peakHeight;
    if baseLevel < 3*noiseLevel
        % 1.5*5 =7.5 times rmsd
        disp("Resetting baselevel to be 3*noise level ...")
        baseLevel = 3*noiseLevel;                     % reset to minimally the 2*noiseFloor
    end
end


posCntLvls=[baseLevel];
for i=2:numLvls
    posCntLvls=[posCntLvls cntFactor*posCntLvls(i-1)];
end
negCntLvls=[-baseLevel];
for i=2:numLvls
    negCntLvls=[cntFactor*negCntLvls(1) negCntLvls];
end

cntLvls = [negCntLvls posCntLvls];

% set colors
% 1. black   = 'k' = [0,0,0]
% 2. red     = 'r' = [1,0,0]
% 3. magenta = 'm' = [1,0,1]
% 4. orange  =     = [1,0.5,0]
% 5. yellow  =     = [0.8,0.7,0]
% 6. green   = 'g' = [0,1,0]
% 7. cyan    = 'c' = [0,1,1]
% 8. blue    = 'b' = [0,0,1]
% 9. purple  =     = [0.6,0,0.8]
% 10. olive  =     = [0.5,0.5,0.4]
% 11. teal   =     = [0.3,0.4,0.5]

%colorPlot = ['k';'r';'m';'b';'c';'y';'g'];
% 
% change yellow to dark yellow for better contrast, also added orange
% this works: colorPlot=[[1,0,0];[1,1,1]]; plot(sin([0:0.1:6]),'color', colorPlot(1,:))
colorPlot = [[0,0,0];[1,0,0];[1,0,1];[1,0.5,0];[0.8,0.7,0];[0,1,0]; [0,1,1];[0,0,1];[0.6,0,0.8];[0.5,0.5,0.4];[0.3,0.4,0.5]];
colorNames = ['bk';'rd';'ma';'or';'yl';'gr';'cy';'bl';'pu';'ol';'tl'];

% plot 2D
if titrationPoint == 1
    % remove hold to remove previous spectra if any
    % need to switch to figure(2) since student may have other figure window active (coneView for instance)
    figure(2)
    hold off;
else
    figure(2)
    hold on;
end

figure(2)
if sino > 5
    colorIdx = mod(tp-1,length(colorPlot))+1;
    if ppmaxis == 1
        
        contour(asHppm, asNppm, Sr, cntLvls, 'linecolor',colorPlot(colorIdx,:));
        xlabel('1H (ppm)')
        ylabel('15N (ppm)')
        set(gca,'XDir','reverse')
        set(gca,'YDir','reverse')
    else
        contour(asH, asN, Sr, cntLvls, 'linecolor',colorPlot(colorIdx,:));
        xlabel('1H (Hz)')
        ylabel('15N (Hz)')
        axis([-swH/2 swH/2 -swN/2 swN/2]);
    end
else
    %imagesc(asHppm, asNppm, Sr); % does not work?
    disp("Signal-to-noise is too low for a contourplot, showing image instead.")
    imagesc(Sr);                  % does not show axis correctly
end
grid on
titlestr = sprintf("%s (%.1f kDa) titration with %s (%.1f kDa)", acronymProtein, proteinMass, acronymLigand, ligandMass);
title(titlestr,"fontweight","bold")

% put labels
% add amino acids based on aa_string

if tp==1
    for peakNumber=1:numPeaks
        peakLabel = strcat(aa_string(peakNumber),num2str(peakNumber));
        if ppmaxis == 1
            labelShiftPpmN = 0.3;
            labelShiftPpmH = 0.06;
            text(wHvppm(peakNumber)-labelShiftPpmH,wNvppm(peakNumber)-labelShiftPpmN,peakLabel,"fontsize", labelSize);
        else
            pcH = wHv(peakNumber)/(2*my_pi);       % 1H  peak center frequency in Hz
            pcN = wNv(peakNumber)/(2*my_pi);       % 15N peak center frequency in Hz
            text(pcH+labelShift,pcN+labelShift,peakLabel, "fontsize", labelSize);
        end
    end
end


