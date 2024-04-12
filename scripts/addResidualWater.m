% addResidualWater.m

% make fake water signal
w_water = swH*my_pi;    % put water at edge
R2_water = 10;
% define dispersive line shape
% D(w) = (w-w0)/ (R2^2 + (w-w0)^2)
ww = asH*2*my_pi;
water = (ww -w_water)./(R2_water^2 + (ww- w_water).^2);
water2D = zeros(zfN, zfH);
for kk=1:zfN
    water2D(kk,:) = water;
end
% scale by p1/trup , fixed so that at 0.5 us
Sr = Sr + (1-p1/trup)*1000*300*water2D;
