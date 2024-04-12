% zoomFull.m
%
figure(2)
if ppmaxis == 1
    axis([min(asHppm) max(asHppm) min(asNppm) max(asNppm)]);
    xlabel('1H (ppm)')
    ylabel('15N (ppm)')
else
    axis([-swH/2 swH/2 -swN/2 swN/2]);
    xlabel('1H (Hz)')
    ylabel('15N (Hz)')
end
titlestr = sprintf("%s (%.1f kDa) titration with %s (%.1f kDa)", acronymProtein, proteinMass, acronymLigand, ligandMass);
title(titlestr,"fontweight","bold")
