% setupH2O.m
%
% HvI edit May 2015
% set-up matrices and Liouville space for 1-spin system for Octave
% define Pauli spin matrices

% all variables have "1" appended to indicate 1-spin system
% and not to overwrite variables of 2-spin system

% Cartesian basis

Iz = 0.5*[ 1 0; 0 -1 ];
Ix = 0.5*[ 0 1; 1 0 ];
Iy = 0.5*i*[0 -1; 1 0 ];
E =[1 0; 0 1];
% kron computes the kronecker product of matrix A and B = a(i,j)*b 
% construct N=1 2x2 matrix for one-spin system A
%   H =  1H spin, water

% a/b   - H

% So in terms of H:
%  1: a 2: b

Em1=E;

Hx1=Ix;
Hy1=Iy;
Hz1=Iz;

% setup Liouville operator space

v1(:,:,1)=Hx1;				% 1 - obs Hx
v1(:,:,2)=Hy1;				% 2 - obs Hy
v1(:,:,3)=Hz1;				% 3 - equilibrium magnetization Hz
v1(:,:,4)=Em1;			    % 

% calculate Liouvillian for pulses and chemical shift
% see Flemming's Mathematica script FourSpin_NoExch_Numerical

for l = 1:4
	for k=1:4
		lvmHx1(k,l) = trace(conj(v1(:,:,k)')*(-sqrt(-1)*(Hx1*v1(:,:,l)-v1(:,:,l)*Hx1)))/trace(v1(:,:,k)*conj(v1(:,:,k)'));
		lvmHy1(k,l) = trace(conj(v1(:,:,k)')*(-sqrt(-1)*(Hy1*v1(:,:,l)-v1(:,:,l)*Hy1)))/trace(v1(:,:,k)*conj(v1(:,:,k)'));
		lvmHz1(k,l) = trace(conj(v1(:,:,k)')*(-sqrt(-1)*(Hz1*v1(:,:,l)-v1(:,:,l)*Hz1)))/trace(v1(:,:,k)*conj(v1(:,:,k)'));
	end
end

% define some terms

pHx1 = lvmHx1;
pHy1 = lvmHy1;

wHz1 = wH2O*lvmHz1;

% define relaxation matrix

rM1 = zeros(4,4);
rM1(1,1) = R2H2O;
rM1(2,2) = R2H2O;
rM1(3,3) = R1H2O;

% define free precession Liouvillan

LV1 = - wHz1 - rM1;

% predefine matrix exponential for FID recording
LV1_FID		= expm(LV1*dwtH2O);

% observation indices
obsHx1 =1;
obsHy1 =2;


