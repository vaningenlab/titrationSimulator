% fitCurve.m
% script to fit binding curve extracted by student to 1:1 binding model

disp("")
disp("Fitting ....")

k = [1 100];               % fit parameters KD in mM and maxCSP in Hz (peak displacement

klow = [0    0 ];           % upper and lower limits
kup = [1e5 1e4 ];

[x, obj, infol, iter, nf, lambda] = sqp(k', @calcChi2,[],[],klow',kup');   % non-linear optimization of chi2

KD_fit     = x(1);
maxCSP_fit = x(2);

% reasonable error in CSP is bassed on peak pick error
%  15N +/- 0.2 ppm
%   1H +/- 0.02
% CSP error = sqrt(0.02^2+ (0.2/5)^2) = 0.045 / sqrt(0.01^2+ (0.1/5)^2) = 0.022
redChi2 = obj/0.03^2;


% calculate fitted x/y pairs

