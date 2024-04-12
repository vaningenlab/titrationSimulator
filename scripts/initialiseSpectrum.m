% initialiseSpectrum.m
% 
% define numPeaks (fixed) N-H pair wHv, wNv, dwHv, dwNv
% define spectral widths

% define everything in ppm

% define center of spectrum 
centerHppm = 8;       % center of 1H spectrum
centerNppm = 120;       % center of 15N spectrum

% define BMRMB average chemical shifts and std dev
cs.AH = [8.195,0.580];
cs.AN = [123.332,3.459];
cs.RH = [8.236,0.607];
cs.RN = [120.851,3.625];
cs.NH = [8.324,0.610];
cs.NN = [118.924,3.912];
cs.DH = [8.301,0.562];
cs.DN = [120.701,3.770];
cs.CH = [8.387,0.674];
cs.CN = [120.135,4.433];
cs.QH = [8.219,0.574];
cs.QN = [119.992,3.537];
cs.EH = [8.331,0.579];
cs.EN = [120.750,3.435];
cs.GH = [8.332,0.624];
cs.GN = [109.581,3.654];
cs.HH = [8.249,0.668];
cs.HN = [119.717,4.030];
cs.IH = [8.264,0.674];
cs.IN = [121.425,4.209];
cs.LH = [8.217,0.628];
cs.LN = [121.858,3.837];
cs.KH = [8.177,0.591];
cs.KN = [121.061,3.686];
cs.MH = [8.250,0.578];
cs.MN = [120.094,3.474];
cs.FH = [8.338,0.712];
cs.FN = [120.392,4.111];
cs.SH = [8.278,0.570];
cs.SN = [116.293,3.473];
cs.TH = [8.236,0.612];
cs.TN = [115.368,4.708];
cs.WH = [8.266,0.764];
cs.WN = [121.549,4.072];
cs.YH = [8.292,0.722];
cs.YN = [120.489,4.074];
cs.VH = [8.273,0.661];
cs.VN = [121.097,4.410];

% define spectral widths as reasoned above
swHppm         = 4;         % fixed since wH in range 10-6 ppm (8 center)
swNppm         = 30;        % fixed since wN in range 105-135 ppm (120 center) 115-125=10ppm width does not really help to improve appearances
swH            = swHppm*B0*gH*1e-6/(2*my_pi);
swN            = swNppm*B0*abs(gN)*1e-6/(2*my_pi);

% first set random frequencies in range sw for both 1H and 15N
% factor 0.9 to avoid peaks being at edge of spectrum
%wHvppm  = 0.9*(-swHppm/2 + swHppm*rand(1,numPeaks))+ centerHppm;    % peak position in ppm
%wNvppm  = 0.9*(-swNppm/2 + swNppm*rand(1,numPeaks))+ centerNppm;    % peak position in ppm

wHvppm=[];
wNvppm=[];
for aa=1:9
    strH=strcat(aa_string(aa),"H");
    shiftH = cs.(strH)(1)+randn*cs.(strH)(2);
    if shiftH > centerHppm + 0.5*swHppm - 0.1
            % reflect around downfield edge into spectrum % fixed error!
            shiftH = (centerHppm+0.5*swHppm) - (shiftH-(centerHppm+0.5*swHppm)) - 0.15;
    elseif shiftH < centerHppm - 0.5*swHppm + 0.1
            % reflect around upfield edge into spectrum
            shiftH = (centerHppm-0.5*swHppm) + (centerHppm-0.5*swHppm-shiftH) + 0.15;
    end
    wHvppm =[ wHvppm shiftH];
    strN=strcat(aa_string(aa),"N");
    shiftN = cs.(strN)(1)+randn*cs.(strN)(2);
    if shiftN > centerNppm + 0.5*swNppm - 1
            % reflect around downfield edge into spectrum % fixed error
            shiftN = (centerNppm+0.5*swNppm) - (shiftN-(centerNppm+0.5*swNppm)) - 2;
    elseif shiftN < centerNppm - 0.5*swNppm + 1
            % reflect around upfield edge into spectrum
            shiftN = (centerNppm-0.5*swNppm) + (centerNppm-0.5*swNppm-shiftN) + 2;
    end
    wNvppm =[ wNvppm shiftN];
end

% check for overlap, overlap contains indices of overlapping peaks
overlap = [];
for aa=1:9
    shiftHa = wHvppm(aa);
    shiftNa = wNvppm(aa);
    for bb=aa+1:9
        shiftHb = wHvppm(bb);
        shiftNb = wNvppm(bb);
        if abs(shiftHa-shiftHb)<0.05 && abs(shiftNa-shiftNb)<0.5
            overlap = [overlap aa bb];
        end
    end
end

wHv     = -(wHvppm - centerHppm)*B0*gH*1e-6;                              %  1H angular frequency of free protein [rad s-1]
wNv     = -(wNvppm - centerNppm)*B0*gN*1e-6;                              % 15N angular frequency of free protein [rad s-1]

% generate chemical shift difference (all positive)
% in either of three classes: 0-0.1 ppm, 0.1-0.25 ppm, 0.25-0.5 ppm (1H)
% in either of three classes: 0-0.5 ppm, 0.5-1.5 ppm, 1.5-3 ppm (15N)
% maximum shift based on Williamson estimates, favors fast exchange and for more realistic spectra
numSmall = round(numPeaks/3);
numBig   = round(numPeaks/3);
numMed   = numPeaks - numSmall - numBig;
sH = 0.01 + 0.1*rand(1,numSmall);
mH = 0.1 + 0.15*rand(1,numMed);
bH = 0.25 + 0.25*rand(1,numBig);
sN = 0.5*rand(1,numSmall);
mN = 0.5 + 1.0*rand(1,numMed);
bN = 1.0 + 2.0*rand(1,numBig);
% generate random signs
signs = floor(rand(1,2*numPeaks)-0.5);
for p=1:2*numPeaks
    if signs(p) == 0
        signs(p) = 1;
    end
end
% downscale CSPs a bit, 80%
dwHv_o = 0.8*signs(1:numPeaks).*[ sH mH bH ]*gH*B0*1e-6;
dwNv_o = 0.8*signs(numPeaks+1:2*numPeaks).*[ sN mN bN ]*gN*B0*1e-6;
% reshuffle dw vectors in random-order, keep small/medium/large dwN dwH together
indx_order = [1:1:numPeaks];
rand_order = indx_order(randperm(numPeaks));
dwHv = zeros(1,numPeaks);
dwNv = zeros(1,numPeaks);
for r = 1:numPeaks
    dwHv(r) = dwHv_o(rand_order(r));
    dwNv(r) = dwNv_o(rand_order(r));
end
% reset a few (1-2) to zero
numZero=round(1+1*rand());
idxZero=randperm(numPeaks)(1:numZero);
dwHv(idxZero)=0;
dwNv(idxZero)=0;

% now check whether w+dw is compatible; if not reverse direction of shift
% edge of spectrum is sw/2 Hz = sw/2*2*pi = sw*pi in rad s-1
% say 9.5 + 1 > 0.9*10 && 9.5 - 1 > 0.9*6; then OK to revert proton
%     6.5 + -1 < 0.9*6 && 6 - -1 < 0 
for p=1:numPeaks
    if wHv(p) + dwHv(p) > 0.9*swH*my_pi
        % problem at 10ppm: need to do something about since peak would be folded
        if wHv(p) - dwHv(p) > -0.9*swH*my_pi
            % safe to revert; should always be true
            dwHv(p) = -1*dwHv(p);
        else
            % truncate dw to edge
            dwHv(p) = 0.9*swH*my_pi-wHv(p);
        end
    elseif wHv(p) + dwHv(p) < -0.9*swH*my_pi
        % problem at 6ppm: need to do something about since peak would be folded
        if wHv(p) - dwHv(p) < 0.9*swH*my_pi
            % safe to revert; should always be true
            dwHv(p) = -1*dwHv(p);
        else
            % truncate dw to edge
            dwHv(p) = -0.9*swH*my_pi-wHv(p);
        end
    end % otherwise no problem in 1H
    
    if wNv(p) + dwNv(p) > 0.9*swN*my_pi
        % problem at 130 ppm: need to do something about since peak would be folded
        if wNv(p) - dwNv(p) > -0.9*swN*my_pi
            % safe to revert; should always be true
            dwNv(p) = -1*dwNv(p);
        else
            % truncate dw to edge
            dwNv(p) = 0.9*swN*my_pi-wNv(p);
        end
    elseif wNv(p) + dwNv(p) < -0.9*swN*my_pi
        % problem at 105 ppm: need to do something about since peak would be folded
        if wNv(p) - dwNv(p) < 0.9*swN*my_pi
            % safe to revert; should always be true
            dwNv(p) = -1*dwNv(p);
        else
            % truncate dw to edge
            dwNv(p) = -0.9*swN*my_pi-wNv(p);
        end
    end % otherwise no problem in 15N

end

% translate back to ppm values
dwHvppm = dwHv/(gH*B0*1e-6);
dwNvppm = dwNv/(gN*B0*1e-6);



