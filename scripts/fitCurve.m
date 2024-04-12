% fitCurve.m
% sciprt to fit bindingcurve extarcted by student to 1;1 binding model

disp("fitting ....")

k = [1 100];               % fit parameters KD in mM and maxCSP in Hz (peak displacement

klow = [0    0 ];           % upper and lower limits
kup = [1e5 1e4 ];

[x, obj, infol, iter, nf, lambda] = sqp(k', @calcChi2,[],[],klow',kup');   % non-linear optimization of chi2

KD_fit     = x(1);
maxCSP_fit = x(2);

disp("done!")


% calculate fitted x/y pairs

