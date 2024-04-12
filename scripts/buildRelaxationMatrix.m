% buildRelaxationMatrix.m
%

MH0 = pa;
MN0 = pa*gN/gH;

laH_A = laH_Av(peak);
laN_A = laN_Av(peak);
etaH_A = etaH_Av(peak);
etaN_A = etaN_Av(peak);
rhoaH_A = rhoaH_Av(peak);
rhoaN_A = rhoaN_Av(peak);
rhoH_A = rhoH_Av(peak);
rhoN_A = rhoN_Av(peak);
rho2HN_A = rho2HN_Av(peak);
sigma_A = sigma_Av(peak);
deltaH_A = deltaH_Av(peak);
deltaN_A = deltaN_Av(peak);

thH_A = rhoH_A*MH0 + sigma_A*MN0;
thN_A = rhoN_A*MN0 + sigma_A*MH0;
th2HN_A = deltaH_A*MH0 + deltaN_A*MN0;

laMQ_A = laMQ_Av(peak);
muMQ_A = muMQ_Av(peak);

laH_B = laH_Bv(peak);
laN_B = laN_Bv(peak);
etaH_B = etaH_Bv(peak);
etaN_B = etaN_Bv(peak);
rhoaH_B = rhoaH_Bv(peak);
rhoaN_B = rhoaN_Bv(peak);
rhoH_B = rhoH_Bv(peak);
rhoN_B = rhoN_Bv(peak);
rho2HN_B = rho2HN_Bv(peak);
sigma_B = sigma_Bv(peak);
deltaH_B = deltaH_Bv(peak);
deltaN_B = deltaN_Bv(peak);

thH_B = rhoH_B*MH0 + sigma_B*MN0;
thN_B = rhoN_B*MN0 + sigma_B*MH0;
th2HN_B = deltaH_B*MH0 + deltaN_B*MN0;

laMQ_B = laMQ_Bv(peak);
muMQ_B = muMQ_Bv(peak);

rA 			= zeros(16,16);	% initialise for state A

rA(1,1) 	= laH_A;		% Hx (1) auto-relaxation transverse in-phase
rA(1,11)	= etaH_A;		% Hx (1) transverse cross-correlation rate Ix<->IxSz (11)
rA(2,2) 	= laH_A;		% Hy (2) auto-relaxation transverse in-phase
rA(2,13)	= etaH_A;		% Hy (2) transverse cross-correlation rate Iy<->IySz (13)

rA(4,4) 	= laN_A;		% Nx (4) auto-relaxation transverse in-phase
rA(4,14)	= etaN_A;		% Nx (4) transverse cross-correlation rate Sx<->IzSx (14)
rA(5,5) 	= laN_A;		% Ny (5) auto-relaxation transverse in-phase
rA(5,15)	= etaN_A;		% Ny (5) transverse cross-correlation rate Sy<->IzSy (15)

rA(11,1)	= etaH_A;		% HxNz (11) transverse cross-correlation rate Ix<->IxSz (1)
rA(11,11)	= rhoaH_A;		% HxNz (11) auto-relaxation transverse anti-phase
rA(13,2)	= etaH_A;		% HyNz (13) transverse cross-correlation rate Iy<->IySz (2)
rA(13,13)	= rhoaH_A;		% HyNz (13) auto-relaxation transverse anti-phase

rA(14,4)	= etaN_A;		% HzNx (14) transverse cross-correlation rate Sx<->IzSx (4)
rA(14,14)	= rhoaN_A;		% HzNx (14) auto-relaxation transverse anti-phase
rA(15,5)	= etaN_A;		% HzNy (15) transverse cross-correlation rate Sy<->IzSy (5)
rA(15,15)	= rhoaN_A;		% HzNy (15) auto-relaxation transverse anti-phase

rA(3,3) 	= rhoH_A;		% Hz (3) auto-relaxation longitudinal
rA(3,6)		= sigma_A;		% Hz (3) - Nz (6) cross-relaxation
rA(3,9)		= deltaH_A;		% Hz (3) - HzNz (9) longitudinal cross-correlation rate
rA(3,16) 	= -2*thH_A;		% Hz (3) - Em (16) coupling to chemical equilibrium

rA(6,6) 	= rhoN_A;		% Nz (6) auto-relaxation longitudinal
rA(6,3)		= sigma_A;		% Nz (6) - Hz (3) cross-relaxation
rA(6,9)		= deltaN_A;		% Nz (6) - HzNz (9) longitudinal cross-correlation rate
rA(6,16) 	= -2*thN_A;		% Nz (6) - Em (16) coupling to chemical equilibrium

rA(9,9) 	= rho2HN_A;		% HzNz (9) auto-relaxation longitudinal two-spin-order
rA(9,3)		= deltaH_A;		% HzNz (9) - Hz (3) longitudinal cross-correlation rate
rA(9,6)		= deltaN_A;		% HzNz (9) - Nz (6) longitudinal cross-correlation rate
rA(9,16) 	= -2*th2HN_A;	% HzNz (9) - Em (16) coupling to chemical equilibrium

rA(7,7)		= laMQ_A;		% HxNx (7) auto-relaxation multiple-quantum
rA(7,8)		= -muMQ_A;		% HxNx (7) - HyNy (8) multiple-quantum cross-relaxation

rA(8,8)		= laMQ_A;		% HyNy (8) auto-relaxation multiple-quantum
rA(8,7)		= -muMQ_A;		% HyNy (8) - HyNy (7) multiple-quantum cross-relaxation

rA(10,10)	= laMQ_A;			% HxNy (10) auto-relaxation multiple-quantum
rA(10,12)	= muMQ_A;			% HxNy (10) - HyNx (12) multiple-quantum cross-relaxation

rA(12,12)	= laMQ_A;			% HyNx (12) auto-relaxation multiple-quantum
rA(12,10)	= muMQ_A;			% HyNx (12) - HxNy (10) multiple-quantum cross-relaxation

rB 			= zeros(16,16);	% initialise for state B

rB(1,1) 	= laH_B;		% Hx (1) auto-relaxation transverse in-phase
rB(1,11)	= etaH_B;		% Hx (1) transverse cross-correlation rate Ix<->IxSz (11)
rB(2,2) 	= laH_B;		% Hy (2) auto-relaxation transverse in-phase
rB(2,13)	= etaH_B;		% Hy (2) transverse cross-correlation rate Iy<->IySz (13)

rB(4,4) 	= laN_B;		% Nx (4) auto-relaxation transverse in-phase
rB(4,14)	= etaN_B;		% Nx (4) transverse cross-correlation rate Sx<->IzSx (14)
rB(5,5) 	= laN_B;		% Ny (5) auto-relaxation transverse in-phase
rB(5,15)	= etaN_B;		% Ny (5) transverse cross-correlation rate Sy<->IzSy (15)

rB(11,1)	= etaH_B;		% HxNz (11) transverse cross-correlation rate Ix<->IxSz (1)
rB(11,11)	= rhoaH_B;		% HxNz (11) auto-relaxation transverse anti-phase
rB(13,2)	= etaH_B;		% HyNz (13) transverse cross-correlation rate Iy<->IySz (2)
rB(13,13)	= rhoaH_B;		% HyNz (13) auto-relaxation transverse anti-phase

rB(14,4)	= etaN_B;		% HzNx (14) transverse cross-correlation rate Sx<->IzSx (4)
rB(14,14)	= rhoaN_B;		% HzNx (14) auto-relaxation transverse anti-phase
rB(15,5)	= etaN_B;		% HzNy (15) transverse cross-correlation rate Sy<->IzSy (5)
rB(15,15)	= rhoaN_B;		% HzNy (15) auto-relaxation transverse anti-phase

rB(3,3) 	= rhoH_B;		% Hz (3) auto-relaxation longitudinal
rB(3,6)		= sigma_B;		% Hz (3) - Nz (6) cross-relaxation
rB(3,9)		= deltaH_B;		% Hz (3) - HzNz (9) longitudinal cross-correlation rate
rB(3,16) 	= -2*thH_B;		% Hz (3) - Em (16) coupling to chemical equilibrium

rB(6,6) 	= rhoN_B;		% Nz (6) auto-relaxation longitudinal
rB(6,3)		= sigma_B;		% Nz (6) - Hz (3) cross-relaxation
rB(6,9)		= deltaN_B;		% Nz (6) - HzNz (9) longitudinal cross-correlation rate
rB(6,16) 	= -2*thN_B;		% Nz (6) - Em (16) coupling to chemical equilibrium

rB(9,9) 	= rho2HN_B;		% HzNz (9) auto-relaxation longitudinal two-spin-order
rB(9,3)		= deltaH_B;		% HzNz (9) - Hz (3) longitudinal cross-correlation rate
rB(9,6)		= deltaN_B;		% HzNz (9) - Nz (6) longitudinal cross-correlation rate
rB(9,16) 	= -2*th2HN_B;	% HzNz (9) - Em (16) coupling to chemical equilibrium

rB(7,7)		= laMQ_B;		% HxNx (7) auto-relaxation multiple-quantum
rB(7,8)		= -muMQ_B;		% HxNx (7) - HyNy (8) multiple-quantum cross-relaxation

rB(8,8)		= laMQ_B;		% HyNy (8) auto-relaxation multiple-quantum
rB(8,7)		= -muMQ_B;		% HyNy (8) - HyNy (7) multiple-quantum cross-relaxation

rB(10,10)	= laMQ_B;			% HxNy (10) auto-relaxation multiple-quantum
rB(10,12)	= muMQ_B;			% HxNy (10) - HyNx (12) multiple-quantum cross-relaxation

rB(12,12)	= laMQ_B;			% HyNx (12) auto-relaxation multiple-quantum
rB(12,10)	= muMQ_B;			% HyNx (12) - HxNy (10) multiple-quantum cross-relaxation


rM = blkdiag(rA,rB);
 

