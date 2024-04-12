% weightFID.m
% HvI Jun 2010/ March 2011
%
% applying weighting function, NMRPipe style
% with first point correction for acquisition starting at zero time

function retval = weightFID(dataFID, SW, windowType, firstPointScale, arg1, arg2, arg3)

	global my_pi

	[tp tSize]  = size(dataFID);				% redefine data size
	wi			= [0:1:(tSize-1)];				% initialize weights with index 0...dimt-1
	t			= wi/SW;						% reconstruct time vector
		
	if windowType == 'SP'
	
		% arg1 = off	% arg2 = end	% arg3 = pow
		% SP[i] = sin (PI*off + PI*(end-off)*i/tSize-1)^pow
	
		wi	= sin(my_pi*arg1 +my_pi*(arg2-arg1)*wi/(tSize-1)).^arg3;

	elseif windowType == 'GT'
			
		% arg1 = lb	(-1..-lw) % arg2 = gb (~0.1)	% arg3 = not used
		% GMB[i] = exp( -a*t - b*t*t)
		%	t = i/SW
		%	aq = tSize/SW
		%   
	
		aq = tSize/SW;
		a  = PI*arg1;
		b  = -a/(2*arg2*aq);
		
		wi	= exp( -a*t - b*t.*t);

	
	elseif windowType == 'GM'
	
	
		% arg1 = g1  arg2= g2	arg3=g3
		% GM[i] = exp( e - g*g)
		%	e = PI * i * g1/SW
		% 	g = 0.6*PI*g2*(g3*(tSize-1)-i)/SW
		
		e =my_pi*wi*arg1/SW;
		g = 0.6*my_pi*arg2* ( arg3*(tSize-1)-wi )/SW;
		
		wi = exp( e -g.*g);
		
	else
	
		wi = ones(1,tSize);					% no weighting
	
	end
	
	Mw	= dataFID(1:tp,:).*kron(wi,ones(tp,1));		% apply window along rows
	Mw(:,1) = Mw(:,1)*firstPointScale;				% adjust firstPoint
	
	retval = Mw;

end
