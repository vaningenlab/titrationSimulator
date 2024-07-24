% zoomFull.m
%
figure(2)
axis([min(asHppm) max(asHppm) min(asNppm) max(asNppm)]);
xlabel('1H (ppm)')
ylabel('15N (ppm)')
titlestr = sprintf("%s (%.1f kDa) titration with %s (%.1f kDa)", acronymProtein, proteinMass, acronymLigand, ligandMass);
title(titlestr,"fontweight","bold")
