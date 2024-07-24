% buildExchangeMatrix.m
%
% define exchange matrix for 2 state exchange
% this only depends on titration point, not on peak

kb = koff;              % backward rate is koff
kf = koff/KD*Lf;        % pseudo forward-rate (everything in mM units)
pa = Ef/E0;             % A will be free protein (actual)
pb = C/E0;              % B will be complexed protein (actual)

% build exchange matrix

kM1 = -kf*eye(16);
kM2 = -kb*eye(16);
kM3 = kb*eye(16);
kM4 = kf*eye(16);

kM = [kM1 kM3; kM4 kM2];

%   dP/dt = -kon*[P]*[L] + koff*[PL]= -kl*[P] + koff*[PL]
%   kl = kon*[L] 
%   koff/kon = KD <=> kon = koff/KD
%   this kl = koff/KD*L
