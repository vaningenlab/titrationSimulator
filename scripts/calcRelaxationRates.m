% calcRelaxationRates.m
%
% takes proteinMass / ligandMass / S2values to calculate relaxation rates
% free protein has _A suffix
% bound protein has _B suffix

% assuming isotropic overall tumbling
% assuming N-H system w/ DD and axially symmetric CSA

% generate S2 order parameters for N-H bond (9 values)
% in either of three classes: 0.3-0.6, 0.6-0.8, 0.8-1
lowS2       = 0.3 + 0.3*rand(1,2);
mediumS2    = 0.6 + 0.2*rand(1,2);
bigS2       = 0.8 + 0.2*rand(1,5);
S2Values    = [ lowS2 mediumS2 bigS2 ];
% does not matter if ordered since peak positions are random anyways
% but need to check that min and max are assigned to overlapping peaks!
% so peak 1 2 or 3 is min and should not overlap with peak 7 or 8 9


% fixed parameters
hbar = 1.0546e-34;      % Planck's constant over 2*my_pi [J s ]
CSAN = -172e-6;         % 15N chemical shift anisotropy [ppm]
CSAH = 10e-6;           % 1H  chemical shift anisotropy [ppm]
rNH  = 1.02e-10;        % distance N-H [A]
JNH  = -92;             % 1H-15N 1J coupling constant [Hz]
rHH  = 1.85e-10;         % 1HN - 1Halpha distance [A] Lewis: 2.25 Yang 1.85
te   = 0.1e-9;          % correlation time internal motions [s] (fixed at 100 ps)
phiN = 20*my_pi/180;       % angle dipolar and CSA frames for 15N [rad]
phiH = 0;               % angle dipolar and CSA frames for 1H [rad]
mu0f = 1e-7;            % permeability of vacuum factor mu0/(4pi)
                        % Palmer: mu0 = 4*my_pi*1e-7

% derive global rotational correlation time from molecular mass
% using rough estimation tc = 0.6*mass in kDa
tc_A = 0.6*proteinMass*1e-9;
tc_B = 0.6*(proteinMass+ligandMass)*1e-9;
ti_A = 1/(1/tc_A + 1/te);  % internal motion effective correlation time Allard Eq. 16
ti_B = 1/(1/tc_B + 1/te);  % internal motion effective correlation time Allard Eq. 16

% evalute spectral densities J(0), J(wH), J(wN), J(wH-wN), J(wH+wN)
% using Lipari-Szabo model-free formalism
% since these are absolute frequencies we can safely ignore chemical shifts and exchange
% since S2 differ for each peaks the J(w) are a vector
% 1. evaluate resonance frequencies (ignoring chemical shift)
wHr = gH*B0;
wNr = gN*B0;
% 2. define spectral densities for each peak:
J0_Av       = zeros(1,9);
JwH_Av      = zeros(1,9);
JwN_Av      = zeros(1,9);
JwHpN_Av    = zeros(1,9);
JwHmN_Av    = zeros(1,9);
J0_Bv       = zeros(1,9);
JwH_Bv      = zeros(1,9);
JwN_Bv      = zeros(1,9);
JwHpN_Bv    = zeros(1,9);
JwHmN_Bv    = zeros(1,9);

% changed to Allard style
for p=1:9
    S2          = S2Values(p);
    J0_Av(p)    = 2/5*( S2*tc_A/1 + (1-S2)*ti_A/1);
    JwH_Av(p)   = 2/5*( S2*tc_A/(1+(wHr*tc_A)^2) + (1-S2)*ti_A/(1+(wHr*ti_A)^2));
    JwN_Av(p)   = 2/5*( S2*tc_A/(1+(wNr*tc_A)^2) + (1-S2)*ti_A/(1+(wNr*ti_A)^2));
    JwHpN_Av(p) = 2/5*( S2*tc_A/(1+((wHr+wNr)*tc_A)^2) + (1-S2)*ti_A/(1+((wHr+wNr)*ti_A)^2));
    JwHmN_Av(p) = 2/5*( S2*tc_A/(1+((wHr-wNr)*tc_A)^2) + (1-S2)*ti_A/(1+((wHr-wNr)*ti_A)^2));
    J0_Bv(p)    = 2/5*( S2*tc_B/1 + (1-S2)*ti_B/1);
    JwH_Bv(p)   = 2/5*( S2*tc_B/(1+(wHr*tc_B)^2) + (1-S2)*ti_B/(1+(wHr*ti_B)^2));
    JwN_Bv(p)   = 2/5*( S2*tc_B/(1+(wNr*tc_B)^2) + (1-S2)*ti_B/(1+(wNr*ti_B)^2));
    JwHpN_Bv(p) = 2/5*( S2*tc_B/(1+((wHr+wNr)*tc_B)^2) + (1-S2)*ti_B/(1+((wHr+wNr)*ti_B)^2));
    JwHmN_Bv(p) = 2/5*( S2*tc_B/(1+((wHr-wNr)*tc_B)^2) + (1-S2)*ti_B/(1+((wHr-wNr)*ti_B)^2));
    JwHpH_Av(p) = 2/5*( S2*tc_A/(1+((wHr+wHr)*tc_A)^2) + (1-S2)*ti_A/(1+((wHr+wHr)*ti_A)^2));
    JwHpH_Bv(p) = 2/5*( S2*tc_B/(1+((wHr+wHr)*tc_B)^2) + (1-S2)*ti_B/(1+((wHr+wHr)*ti_B)^2));
end

% calculate relaxation rates

dHN = 3*mu0f*hbar*gN*gH*rNH^(-3);   % DD interaction constant: Helgstrand has factor 3! see below
cN = -CSAN*gN*B0;                   % CSA interaction constant 15N; Palmer has factor 1/3 in square
cH = -CSAH*gH*B0;                   % CSA interaction constant 1H; but here 1/3 is eq. below

dHH   = 3*mu0f*hbar*gH*gH*rHH^(-3);  % DD interaction constant: Helgstrand/Allard has factor 3! see below Eq. 14
laHH_A  = 1/36*dHH^2*( 2*J0_Av + 3/2*JwH_Av + 1/2*J0_Av + 3*JwH_Av + 3*JwHpH_Av);  % this gives reasonable values comped to Kay styl for proton at 2.25 A
rhoHH_A = 1/36*dHH^2*( 3*JwH_Av + 1*J0_Av + 6*JwHpH_Av);
laHH_B  = 1/36*dHH^2*( 2*J0_Bv + 3/2*JwH_Bv + 1/2*J0_Bv + 3*JwH_Bv + 3*JwHpH_Bv);  % this gives reasonable values comped to Kay styl for proton at 2.25 A
rhoHH_B = 1/36*dHH^2*( 3*JwH_Bv + 1*J0_Bv + 6*JwHpH_Bv);

% longitudinal rates

% Helgstrand has 1/36 instead of 1/4 but factor 3 in dHN so 9/36 = 1/4
rhoN_Av   = 1/36*dHN^2*(3*JwN_Av + 1*JwHmN_Av + 6*JwHpN_Av) + 1/3*cN^2*JwN_Av;               % Nz auto
rhoH_Av   = 1/36*dHN^2*(3*JwH_Av + 1*JwHmN_Av + 6*JwHpN_Av) + 1/3*cH^2*JwH_Av + rhoHH_A;       % Hz auto
rho2HN_Av = 1/36*dHN^2*(3*JwN_Av + 3*JwH_Av) + 1/3*cN^2*JwN_Av + 1/3*cH^2*JwH_Av + rhoHH_A;    % HzNz auto

sigma_Av  = 1/36*dHN^2*(6*JwHpN_Av - 1*JwHmN_Av);                                    % cross-relaxation
deltaN_Av = 1/3*dHN*cN*1/2*(3*(cos(phiN))^2-1)*JwN_Av;                                  % cross-correlation
deltaH_Av = 1/3*dHN*cH*1/2*(3*(cos(phiH))^2-1)*JwH_Av;                                  % cross-correlation

rhoN_Bv   = 1/36*dHN^2*(3*JwN_Bv + 1*JwHmN_Bv + 6*JwHpN_Bv) + 1/3*cN^2*JwN_Bv;       % Nz auto
rhoH_Bv   = 1/36*dHN^2*(3*JwH_Bv + 1*JwHmN_Bv + 6*JwHpN_Bv) + 1/3*cH^2*JwH_Bv + rhoHH_B;       % Hz auto
rho2HN_Bv = 1/36*dHN^2*(3*JwN_Bv + 3*JwH_Bv) + 1/3*cN^2*JwN_Bv + 1/3*cH^2*JwH_Bv +rhoHH_B;    % HzNz auto

sigma_Bv  = 1/36*dHN^2*(6*JwHpN_Bv - 1*JwHmN_Bv);                                    % cross-relaxation
deltaN_Bv = 1/3*dHN*cN*1/2*(3*(cos(phiN))^2-1)*JwN_Bv;                                  % cross-correlation
deltaH_Bv = 1/3*dHN*cH*1/2*(3*(cos(phiH))^2-1)*JwH_Bv;                                  % cross-correlation
% Palmer writes P2cos(theta) = 0.5*(3*cos(theta)^2-1)

% transverse rates

% Helgstrand has 1/36 instead of 1/4 but factor 3 in dHH so 9/36 = 1/4
laN_Av = 1/36*dHN^2*( 2*J0_Av + 3/2*JwN_Av + 1/2*JwHmN_Av + 3*JwH_Av + 3*JwHpN_Av) ...
            + 1/3*cN^2*(2/3*J0_Av+1/2*JwN_Av);                                      % Nxy auto
laH_Av = 1/36*dHN^2*( 2*J0_Av + 3*JwN_Av + 1/2*JwHmN_Av + 3/2*JwH_Av + 3*JwHpN_Av) ...
            + 1/3*cH^2*(2/3*J0_Av+1/2*JwH_Av) + laHH_A;                                      % Hxy auto

rhoaN_Av = 1/36*dHN^2*(2*J0_Av + 3/2*JwN_Av + 1/2*JwHmN_Av + 3*JwHpN_Av) ...
            + 1/3*cH^2*JwH_Av + 1/3*cN^2*(2/3*J0_Av + 1/2*JwN_Av) + rhoHH_A;                  % HzNxy auto
rhoaH_Av = 1/36*dHN^2*(2*J0_Av + 3/2*JwH_Av + 1/2*JwHmN_Av + 3*JwHpN_Av) ...
            + 1/3*cN^2*JwN_Av + 1/3*cH^2*(2/3*J0_Av + 1/2*JwH_Av) + laHH_A;                  % HxyNz auto

% check factor 0.5 of Helgstrand! 
% Palmer writes 1/6 P2cos(theta)*(4J(0)+3J(w)) = 1/12 (3cos^2-1) ( 4J0 + 3Jw)
% = 1/2 (3cos^2-1) (4/6 J0 + 3/6 Jw) so correct
etaN_Av = 1/3*0.5*dHN*cN*(3*(cos(phiN))^2-1)*(2/3*J0_Av+1/2*JwN_Av);                    % cross-correlation
etaH_Av = 1/3*0.5*dHN*cH*(3*(cos(phiH))^2-1)*(2/3*J0_Av+1/2*JwH_Av);                    % cross-correlation

laN_Bv = 1/36*dHN^2*( 2*J0_Bv + 3/2*JwN_Bv + 1/2*JwHmN_Bv + 3*JwH_Bv + 3*JwHpN_Bv) ...
            + 1/3*cN^2*(2/3*J0_Bv+1/2*JwN_Bv);                                      % Nxy auto
laH_Bv = 1/36*dHN^2*( 2*J0_Bv + 3*JwN_Bv + 1/2*JwHmN_Bv + 3/2*JwH_Bv + 3*JwHpN_Bv) ...
            + 1/3*cH^2*(2/3*J0_Bv+1/2*JwH_Bv) + laHH_B;                                      % Hxy auto

rhoaN_Bv = 1/36*dHN^2*(2*J0_Bv + 3/2*JwN_Bv + 1/2*JwHmN_Bv + 3*JwHpN_Bv) ...
            + 1/3*cH^2*JwH_Bv + 1/3*cN^2*(2/3*J0_Bv + 1/2*JwN_Bv) + rhoHH_B;                  % HzNxy auto
rhoaH_Bv = 1/36*dHN^2*(2*J0_Bv + 3/2*JwH_Bv + 1/2*JwHmN_Bv + 3*JwHpN_Bv) ...
            + 1/3*cN^2*JwN_Bv + 1/3*cH^2*(2/3*J0_Bv + 1/2*JwH_Bv) + laHH_B;                  % HxyNz auto

% check factor 0.5 of Helgstrand!
% Palmer writes 1/6 P2cos(theta)*(4J(0)+3J(w)) = 1/12 (3cos^2-1) ( 4J0 + 3Jw)
% = 1/2 (3cos^2-1) (4/6 J0 + 3/6 Jw) so correct
etaN_Bv = 1/3*0.5*dHN*cN*(3*(cos(phiN))^2-1)*(2/3*J0_Bv+1/2*JwN_Bv);                    % cross-correlation
etaH_Bv = 1/3*0.5*dHN*cH*(3*(cos(phiH))^2-1)*(2/3*J0_Bv+1/2*JwH_Bv);                    % cross-correlation

% multiple quantum rates

laMQ_Av = 1/36*dHN^2*(3/2*JwN_Av + 1/2*JwHmN_Av + 3/2*JwH_Av + 3*JwHpN_Av) ...
            + 1/3*cN^2*(2/3*J0_Av + 1/2*JwN_Av) + 1/3*cH^2*(2/3*J0_Av + 1/2*JwH_Av) + laHH_A;
% check factor 1/2 of Helgstrand!!
muMQ_Av = 1/36*dHN^2*(3*JwHpN_Av - 1/2*JwHmN_Av);

laMQ_Bv = 1/36*dHN^2*(3/2*JwN_Bv + 1/2*JwHmN_Bv + 3/2*JwH_Bv + 3*JwHpN_Bv) ...
            + 1/3*cN^2*(2/3*J0_Bv + 1/2*JwN_Bv) + 1/3*cH^2*(2/3*J0_Bv + 1/2*JwH_Bv) + laHH_B;
% check factor 1/2 of Helgstrand!
% not given in Palmer! 
muMQ_Bv = 1/36*dHN^2*(3*JwHpN_Bv - 1/2*JwHmN_Bv);

