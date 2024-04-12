% processFID.m
% HvI Apr 2011

% do 1D dimensional processing of FID, implemented as a function
% FID is a matrix, so need to know which dimension to process!
% default is along rows
% output is spectrum along columns UNLESS transpose = 1 !

function retval = processFID(FID, zf, wdw, bc, transpose, reverse, sw)

	% weight FID
	
	if wdw == 0 
		% do cosine-squared to observe "natural" line-width
		Mw	= weightFID(FID, sw, 'SP', 0.5, 0.5, 1.0, 2.0); 
	else
		% do Lorentz-to-Gauss transformation w/ substantial broadening
		Mw	= weightFID(FID, sw, 'GM', 0.5, 5, 30, 0);      
	end
	
	% FT and discard imaginaries
	
	Sp	= real(fft(Mw', zf));		% FT works on columns, 2nd number controls zerofilling
									% discard imaginaries
									
	% reshuffle data; swap first half of columns with second half = left and right half of spectrum
	
	Sh1 = Sp(1:zf/2,:);
	Sh2 = Sp(zf/2+1:zf,:);
	Sc	= [Sh2 ; Sh1];				% spectrum is now along columns
				
	% final transpose back to rows if requested
	
	if  transpose == 1
		St = Sc';					% transpose; spectrum is back along rows
	else
		St = Sc;					% no transpose; spectrum is still along columns
	end
	
	% reverse spectrum to get proper peakpositions - along rows
	
	if reverse == 1
		Sr = fliplr(St);
	else
		Sr = St;
	end

	retval = Sr;			
	
end	

