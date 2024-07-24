% coneView.m

if plotPoints == 0
    disp("")
    disp("Nothing to show...")
    disp("First record and process a 2D HSQC experiment.")
    disp("Type \"zg\" and \"xfb\" to do this.")
    disp("")
else
    disp("")
    disp("\tPlotting...")
    if strcmp(graphics_toolkit, 'qt') == 1
        disp("\tClick the rotate icon in the figure window menu bar to activate rotation.")
        disp("\tThen click, hold and drag mouse to rotate the plot.")
        disp("\tYou can click the zoom button in the figure window menu bar to drag-select a zoom region.")
        disp("\tClick the button with a 1 inside the magnifying glass to go back to the full view.")
    elseif strcmp(graphics_toolkit, 'fltk') == 1
        disp("\tClick the \"R\" button on the bottom of the figure window to activate rotation.")
        disp("\tThen left click inside the figure window to rotate the plot.")
        disp("\tNote that this can be very slow.")
        disp("\tIssue \"coneView\" again to go back to the default view.")
    elseif strcmp(graphics_toolkit, 'gnuplot') == 1
        disp("\tUse the mouse inside the figure window to rotate the plot.")
        disp("\tNote that this can be very slow.")
        disp("\tIssue \"coneView\" again to go back to the default view.")
    end
    disp("")
    figure(3);
    mesh(asHppm, asNppm, Sr);
    xlabel('1H (ppm)')
    ylabel('15N (ppm)')
    set(gca,'XDir','reverse')
    set(gca,'YDir','reverse')
    titlestr = sprintf("1H-15N HSQC spectrum of %s (%.1f kDa)\n\n titration point %d", acronymProtein, proteinMass, titrationPoint);
    title(titlestr,"fontweight","bold")
end

