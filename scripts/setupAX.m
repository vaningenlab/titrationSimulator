% setupAX.m
%
% HvI edit May 2015
% set-up matrices and Liouville space for 2-spin system for Octave
% define Pauli spin matrices
% adapt for two-site exchange
% checked definitions against Helgstrand 2000

% Cartesian basis

Iz = 0.5*[ 1 0; 0 -1 ];
Ix = 0.5*[ 0 1; 1 0 ];
Iy = 0.5*i*[0 -1; 1 0 ];
E =[1 0; 0 1];

% kron computes the kronecker product of matrix A and B = a(i,j)*b 
% construct N=2 4x4 matrix for two-spin system A and X
%   H =  1H spin, 1J coupled to N
%   N = 15N spin, 1J coupled to H

% a/b   - H
% aa/bb - N

% So in terms of HN:
%  1: aa 2: ba 3: ab 4: bb 

Em=kron(E,E);

Nx=kron(Ix,E);
Ny=kron(Iy,E); 
Nz=kron(Iz,E);

Hx=kron(E,Ix);
Hy=kron(E,Iy);
Hz=kron(E,Iz);

% setup Liouville operator space
% a little bit odd ordering, but does not matter

v(:,:,1)=Hx;				% 1 - obs Hx
v(:,:,2)=Hy;				% 2 - obs Hy
v(:,:,3)=Hz;				% 3 - equilibrium magnetization Hz
v(:,:,4)=Nx;
v(:,:,5)=Ny;
v(:,:,6)=Nz;
v(:,:,7)=2*Hx*Nx;
v(:,:,8)=2*Hy*Ny;			% 8 - HyNy generated in first INEPT!
v(:,:,9)=2*Hz*Nz;
v(:,:,10)=2*Hx*Ny;
v(:,:,11)=2*Hx*Nz;			% 11 - obs HxNz
v(:,:,12)=2*Hy*Nx;
v(:,:,13)=2*Hy*Nz;			% 13 - obs HyNzs
v(:,:,14)=2*Hz*Nx;
v(:,:,15)=2*Hz*Ny;
v(:,:,16)=1/2*Em;			% Helgstrand uses E/2

% calculate Liouvillian for pulses and chemical shift
% see Flemming's Mathematica script FourSpin_NoExch_Numerical

for l = 1:16
	for k=1:16
		lvmHx(k,l) = trace(conj(v(:,:,k)')*(-i*(Hx*v(:,:,l)-v(:,:,l)*Hx)))/trace(v(:,:,k)*conj(v(:,:,k)'));
		lvmHy(k,l) = trace(conj(v(:,:,k)')*(-i*(Hy*v(:,:,l)-v(:,:,l)*Hy)))/trace(v(:,:,k)*conj(v(:,:,k)'));
		lvmHz(k,l) = trace(conj(v(:,:,k)')*(-i*(Hz*v(:,:,l)-v(:,:,l)*Hz)))/trace(v(:,:,k)*conj(v(:,:,k)'));
		lvmNx(k,l) = trace(conj(v(:,:,k)')*(-i*(Nx*v(:,:,l)-v(:,:,l)*Nx)))/trace(v(:,:,k)*conj(v(:,:,k)'));
		lvmNy(k,l) = trace(conj(v(:,:,k)')*(-i*(Ny*v(:,:,l)-v(:,:,l)*Ny)))/trace(v(:,:,k)*conj(v(:,:,k)'));
		lvmNz(k,l) = trace(conj(v(:,:,k)')*(-i*(Nz*v(:,:,l)-v(:,:,l)*Nz)))/trace(v(:,:,k)*conj(v(:,:,k)'));
		lvmHzNz(k,l) = trace(conj(v(:,:,k)')*(-i*(2*Hz*Nz*v(:,:,l)-v(:,:,l)*2*Hz*Nz)))/trace(v(:,:,k)*conj(v(:,:,k)'));
	end
end

% can already define some terms w/ minor state as long they don't depend on peak

pHx = blkdiag(lvmHx,lvmHx);
pHy = blkdiag(lvmHy,lvmHy);
pNx = blkdiag(lvmNx,lvmNx);
pNy = blkdiag(lvmNy,lvmNy);
pHzNz = blkdiag(lvmHzNz,lvmHzNz);

% define and store matrix exponential for 90/180 pulse for speed
% only 15N pulses, as the 1H pulses are actually calibrated

pNy180 = expm(pNy*my_pi);
pNx180 = expm(pNx*my_pi);

pNx90m = expm(pNx*my_pi*0.5*-1);
pNx90p = expm(pNx*my_pi*0.5*+1);
pNy90m = expm(pNy*my_pi*0.5*-1); 
pNy90p = expm(pNy*my_pi*0.5*+1);


