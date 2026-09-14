% overlayAll.m
% to undo the reduceOverlay

if plotPoints < titrationPoint
    disp("")
    disp("All spectra are reactivated to be overlaid.")
    printf("Issue %s again to update the plot.\n", dispCommand("edlev"))
    disp("")
    plotSpectra = allSpectra;
    plotPoints  = titrationPoint;
else
    disp("")
    disp("Nothing to be done.")
    disp("")
end

