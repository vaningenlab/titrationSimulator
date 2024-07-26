% process2D.m

% transform 1H; both Xy and Xx FIDs

% input is McX and McY both NxH matrices
% so with N rows and H columns, meaning that t1(N) is encoded along column and t2(H) along rows
% one matrix for Nx detected and one matrix for Ny detected to contruct complex 15N FID
% 1H FID is already complex

%         processFID(FID,  zf, wdw, bc, transpose, reverse, sw)
SpHX    = processFID(McX, zfH, 0, 0, 0, 0, swH); # amplitude modulated cosine FID
SpHY    = processFID(McY, zfH, 0, 0, 0, 0, swH); # amplitude modulated sine FID

% recontruct 15N FID and transform

% after 1H processing, 1H is along columns and 15N along rows
% Sr is stable with steps! but not upon re-excution of process2D
%         processFID(FID,            zf, wdw, bc, transpose, reverse,sw)
Sr      = processFID(SpHX + sqrt(-1)*SpHY, zfN, 0, 0, 0, 0, swN);
% after processing 15N is along columns again.

% calculate axis

saxisH		= 1;
for q=2:zfH
	saxisH=[saxisH q];
end
saxisN		= 1;
for q=2:zfN
	saxisN=[saxisN q];
end

asH 	  = (saxisH - zfH/2 )./(zfH/2).*swH/2;			% as in relative Hz -- no point shift to match!
asHppm	  = fliplr(asH*2*my_pi/(gH*B0*1e-6) + centerHppm);

asN 	  = (saxisN - zfN/2 )./(zfN/2).*swN/2;			% as in relative Hz -- no point shift to match!
asNppm	  = fliplr(asN*2*my_pi/(gN*B0*1e-6) + centerNppm);  

% add in residual water from pulse miscalibration
addResidualWater;

% store 2D spectrum in matrix of matrices by appending it

allSpectra(:,:,titrationPoint) = Sr;
plotSpectra = allSpectra; % copy allSpectra into plotSpectra
plotPoints = titrationPoint;


