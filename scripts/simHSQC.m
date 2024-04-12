% simHSQC.m
% GNU Octave / MATLab script to simulate 15N-1H HSQC
%

%============================================================================
%
% now do simulation
%
%============================================================================

cv = StartOp;

cv = pHx90p*cv;					% Hz -> Hy
  cv = LV_INEPT*cv;
cv = pHx180*cv;                 % if considering off-resonance then this must be actually coded as simultaneous
cv = pNx180*cv;
  cv = LV_INEPT*cv;				% HxNz
cv = pHy90p*cv;
%cv = PFG(cv,z,LV_pfg);          % z-filter to kill transverse magnetization
cv = pNx90p*cv;					% HzNy			

start_t1 = cv;

for kk=1:npN 			% for every t1 value
                        % if considering off-resonance then also t1 has to compensated for length of 15N 90's!
	
	t1 	    = tN(kk);								% read t1 value
	LV_t1	= V*diag(exp(diag(D)*(t1/2)))/V;		    % store exponential for speed
	
	cv = start_t1;									% reset to initial state
	
    % 5.	t1-evolution
	
	cv = LV_t1*cv;								% evolve for t1/2
	cv = pHx180*cv;								% 180 1H	
	cv = LV_t1*cv;								% evolve for t1/2
	
	
	% 6.	acquisition loop
	
	cvi = cv;										% store cv before readout pulse
	  
	for p=1:2										% read out X and Y components
		
	  if p == 1
		cv = phaseCycle(cvi,pNx90p,pNx90m,'sub'); 	% read out HzNy after phase cycle
	  else
		cv = phaseCycle(cvi,pNy90p,pNy90m,'sub');	  % read out HzNx after phase cycle
	  end
	  
	  %cv = PFG(cv,z,LV_pfg);          % z-filter to kill transverse magnetization
	  
	  cv = pHy90p*cv;										% HxNz 90y
	                                % if considering off-resonance then also delay has to compensated for length of 1H 90's!
	  
	    cv = LV_INEPT*cv;
	  cv = pHx180*cv;               % if considering off-resonance then this must be actually coded as simultaneous
	  cv = pNx180*cv;
	    cv = LV_INEPT*cv;									% Hy
	
	  
	  % 9.	acquisition direct dimension, include minor state
	
	  FIDx = zeros(1,npH);
	  FIDy = zeros(1,npH);

	  FIDx(1) = real(cv(obsHx) + cv(obsHx2));
	  FIDy(1) = real(cv(obsHy) + cv(obsHy2));	
	  for q=2:npH
		  cv = LV_FID*cv;
	      FIDx(q) = real(cv(obsHx) + cv(obsHx2));
		  FIDy(q) = real(cv(obsHy) + cv(obsHy2));
	  end
	  
	  if p==1
	  	McX(kk,:) = -FIDy + sqrt(-1)*FIDx;   % magnetization is at Hy at start of acq.
	  	                                     % with these definition postive absorptive Lorentzian at right freq.
	  else
	    McY(kk,:) = -FIDy + sqrt(-1)*FIDx;
	  end
	
	end 											% end p-loop frequency discrimination		  	
	
end		

