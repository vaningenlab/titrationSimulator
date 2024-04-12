% simFind90.m

% pulse calibration experiment on water line

% define and store matrix exponential for 90/180 pulse for speed
% only with 

pHx90p1 = expm((2*my_pi*p1)/(4*trup)*pHx1 + LV1*p1*1e-6);

cv = startH2O;
cv = pHx90p1*cv;     % execute 4x 90; including off res effects and relaxation
cv = pHx90p1*cv;
cv = pHx90p1*cv;
cv = pHx90p1*cv;
cvH2O = cv;

FIDx = zeros(1,npH2O);
FIDy = zeros(1,npH2O);

FIDx(1) = real(cv(obsHx1));
FIDy(1) = real(cv(obsHy1));	
for q=2:npH2O
    cv = LV1_FID*cv;
    FIDx(q) = real(cv(obsHx1));
    FIDy(q) = real(cv(obsHy1));
end
% noise scaled such that with p1=0.1 still signal-to-noise of more than 10
noiseH2O = 0.001*(randn(1,npH2O)+sqrt(-1)*randn(1,npH2O));
McH2O = -FIDy + sqrt(-1)*FIDx + noiseH2O;

