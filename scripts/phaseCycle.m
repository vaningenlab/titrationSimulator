% phaseCycle.m

function retval = phaseCycle(vector, prop1, prop2, op);

	tmp1 = prop1*vector;
	tmp2 = prop2*vector;
	if op == 'sub'
		tmp3 = 0.5*(tmp1 - tmp2);
	else
		tmp3 = 0.5*(tmp1 + tmp2);
    end
	tmp3(16)=0.5;
	
	retval = tmp3;

end
