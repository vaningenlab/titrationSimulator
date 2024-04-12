% prepareH2O.m

wH2O = 2;                           % water slightly off resonance
R2H2O = 100;                        % rapid transverse relaxation
R1H2O = 5;                          % rapid longitudinal relaxation due to radiation damping?
swH2O = 1000;                       % spectral width for water
dwtH2O = 1/swH2O;                   % dwell time for water
atH2O = 0.5;                        % 500 ms acq. time  for H2O as in real life
npH2O = round(atH2O/dwtH2O);        % number of points in 1H dim (320)
tH2O = [0:dwtH2O:(npH2O-1)*dwtH2O]; % time vector
%trup = 7 + 5*randn(2,5);           % skewed ditribution so that higher values are less likely
trup = 7 + 5*rand();                % uniform ditribution so that higher values are equally likely
                                    % needed for compatibility with octave 4.4
zfH2O = 2^(round(log2(npH2O))+2);   % zerofill twice
saxisH2O = 1;
for q=2:zfH2O
    saxisH2O = [saxisH2O q];
end
asH2O = (saxisH2O - zfH2O/2 -1)./(zfH2O/2).*swH2O/2;	
