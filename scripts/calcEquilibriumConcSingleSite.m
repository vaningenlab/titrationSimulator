% calcEquilibriumConcSingleSite.m
% HvI Jun 2010
%
% calculates equilibrium concentrations for single set of identical sites model

% HvI 2015, adapted for use in HSQC simulator

n  = 1;                 % single binding site 1:1 stoichiometry
E0 = pConcReal;             % actual total protein concentration (mM)
L0 = molEqReal*E0;          % actual total ligand concentration (mM)
KD = affinityValue*1e3; % dissociation constant (mM)

a	= n;
b	= -(n*E0+L0+KD);
c	= E0.*L0;
x	= (-b-sqrt(b.^2-4*a.*c))./(2*a);
Ef	= (E0-x);			# conc. free protein (mM)
C	= x;				# conc. complex (mM)
Lf	= L0-n*x;			# conc. free ligand (mM)

% 	calculate equilibrium concentrations
%	
%	E + nL <--> C
% 
% 	B:	E0 		+L0		0
% 	O:	-x		-n*x		+x
% 	E:	E0-x		L0-n*x		x
%
% 	KD = [E][L]/[C] = (E0-x)(L0-n*x)/x = E0L0 -n*E0x -L0x +n*x^2/x = n*x^2-(n*E0+L0)x +E0L0/x
%
%  	==> xKD = n*x^2 - (n*E0+L0)x + E0L0 <=> n*x^2 - (n*E0+L0+KD)x + E0L0 = 0


