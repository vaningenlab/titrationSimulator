% overlayAll.m
% to undo the reduceOverlay

if plotPoints < titrationPoint
    disp("")
    disp("All spectra are reactivated to be overlaid.")
    disp("Issue \"edlev\" again to update the plot. ")
    disp("")
    plotSpectra = allSpectra;
    plotPoints  = titrationPoint;
else
    disp("")
    disp("Nothing to be done.")
    disp("")
end

