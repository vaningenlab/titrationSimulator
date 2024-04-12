% reduceOverlay.m

reduceFactor = 4;
numSpectra = titrationPoint;
if numSpectra > maxSpectra
    showSpec   = zeros(1,numSpectra);
    step = round(numSpectra/reduceFactor);
    for tt = 0:reduceFactor
        if tt*step +1 <= numSpectra
            showSpec(tt*step+1) = 1;
        end
    end
    showSpec(numSpectra)=1;
    numDeleted = 0;
    for pp = 1:numSpectra
        if showSpec(pp) == 0
            plotSpectra(:,:,pp-numDeleted)=[];
            numDeleted = numDeleted + 1;
        end
    end
    disp("")
    disp("Number of spectra to be plotted has been reduced.")
    disp("Issue \"edlev\" again to update the plot. ")
    disp("")
else
    showSpec = ones(1,numSpectra);
    disp("")
    printf("Nothing to be done, you have less than %d points.\n", maxSpectra+1)
    disp("")
end
plotPoints = sum(showSpec);
