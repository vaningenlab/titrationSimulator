% setup2D.m

% define start magnetization Hz 
% (no Nz contribution here, purged natural abundance magnetization )

StartOp 	= zeros(16,1);	
StartOp 	= zeros(16,1);
StartOp(3)  = 1;										% 3 - equilibrium magnetization Hz
StartOp		= [pa*StartOp;pb*StartOp];					% include minor-state														
StartOp(16) = 0.5;										% 0.5*identity matrix see Helgstrand paper
StartOp(32) = 0.5;										% 0.5*identity matrix see Helgstrand paper
		% note that scaling of E/2 indentity operator assures correct scaling of equilibrium magnetization
		% without need for separate scaling of cross-terms to identity operator

% define indices of observed magnetization coherences
	
obsHx = 1;	% 1 - obs Hx
obsHy = 2;	% 2 - obs Hy
obsHx2 = 1+16; % state B x
obsHy2 = 2+16; % state B y

% define FID matrix

McX = zeros(npN,npH);
McY = zeros(npN,npH);
