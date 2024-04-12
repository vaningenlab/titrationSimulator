% plotAll.m

% from edlev, but keeping the contouring previously set
% using baseLevel, numLvls, cntFactor

figure(2);
colorPlot  = [[0,0,0];[1,0,0];[1,0,1];[1,0.5,0];[0.8,0.7,0];[0,1,0]; [0,1,1];[0,0,1];[0.6,0,0.8];[0.5,0.5,0.4];[0.3,0.4,0.5]];

for qq=1:plotPoints
    Sr = plotSpectra(:,:,qq);
    if qq == 1
        hold off
    end
    posCntLvls=[baseLevel];
    for n=2:numLvls
        posCntLvls=[posCntLvls cntFactor*posCntLvls(n-1)];
    end
    negCntLvls=[-baseLevel];
    for n=2:numLvls
        negCntLvls=[cntFactor*negCntLvls(1) negCntLvls];
    end
    cntLvls = [negCntLvls posCntLvls];
    colorIdx = mod(qq-1,length(colorPlot))+1;
    if ppmaxis == 1
        contour(asHppm, asNppm, Sr, cntLvls, 'linecolor',colorPlot(colorIdx,:));
        xlabel('1H (ppm)')
        ylabel('15N (ppm)')
        set(gca,'XDir','reverse')
        set(gca,'YDir','reverse')
        hold on
    else
        contour(asH, asN, Sr, cntLvls, 'linecolor',colorPlot(colorIdx,:));
        xlabel('1H (Hz)')
        ylabel('15N (Hz)')
        axis([-swH/2 swH/2 -swN/2 swN/2]);
        hold on
    end
end
% put labels
for peak=1:numPeaks
    peakLabel = strcat(aa_string(peak),num2str(peak));
    if ppmaxis == 0
        text(wHv(peak)/(2*my_pi)+labelShift,wNv(peak)/(2*my_pi)+labelShift,peakLabel, "fontsize", labelSize);
    else
        labelShiftPpmN = 0.3;
        labelShiftPpmH = 0.1;
        text(wHvppm(peak)-labelShiftPpmH,wNvppm(peak)-labelShiftPpmN,peakLabel,"fontsize", labelSize);
        %wNvppm(peak), wNvppm(peak)-labelShiftPpmN
     end
end
grid on;
titlestr = sprintf("%s (%.1f kDa) titration with %s (%.1f kDa)", acronymProtein, proteinMass, acronymLigand, ligandMass);
title(titlestr,"fontweight","bold");