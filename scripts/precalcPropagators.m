% precalcPropagators.m

% as far as they depend on peak

wH  = wHv(peak);
wN  = wNv(peak);
dwH = dwHv(peak);
dwN = dwNv(peak);

wHz = blkdiag(wH*lvmHz,(wH+dwH)*lvmHz);
wNz = blkdiag(wN*lvmNz,(wN+dwN)*lvmNz);

% define free precession Liouvillan

LV = kM - wHz - wNz -my_pi*JNH*pHzNz - rM;

% +wHz gives opposite signs compared to Helgstrand paper for Hx, Hy
% +wNz gives opposite signs compared to Helgstrand paper for Nx, Ny
% +my_pi*J gives opposite signs compared to Helgstrand paper for Hx, HyNz, etc
% HxNx (7) couples to HxNy (10) and HyNx (12) with also opposite signs
% HyNy (8) couples to HxNy (10) and HyNx (12) with also opposite signs
% HzNz (9) only relaxation, just as Hz, Nz

% store diagonalized matrix and eigenvectors of LV for speed
% necessary for free-preccesion periods of variable length delta
[V,D] 		= eig(LV);

% define and store matrix exponential for FID recording
% just remove J-term (perfect decoupling)
LV_dec  	= kM - wHz - wNz - rM;
LV_FID		= expm(LV_dec*dwtH);

% define tau of INEPT and store exponential of LV for speed
% tau is set in ini.m and can be changed by user interactively.
% just check sanity in zg.m
LV_INEPT 	= expm((LV)*tau);

% define LV propagator for PFG
% store diagonalized matrix and eigenvectors of LV for speed
%pPFG        = Gz*tG*(-gH*wHz -gN*Nz);
%LVPFG       = LV + pPFG;
%[Vpfg,Dpfg] = eig(LVPFG);

% store propagator of PFG for each slice for speed

%z    = [-0.005:0.0001:0.005];					% z-position of slices (100)
	
%for i=1:length(z)
%	  	LV_pfg{i}	= Vpfg*diag(exp(diag(Dpfg)*(z(i))))/Vpfg;
%end
