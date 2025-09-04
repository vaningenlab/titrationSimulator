% coneView.m
if plotPoints == 0
    disp("")
    disp("Nothing to show...")
    disp("First record and process a 2D HSQC experiment.")
    disp("Type \"zg\" and \"xfb\" to do this.")
    disp("")
else
    disp("")
    disp("Saving a backup of your work before continuing ...")
    save "state.out"
    disp("")
    disp("\tPlotting...")

    disp("")
    figure(3);
    % now downsize plotted spectrum to avoid crashes on UU PCs
    % calculate zoom regions for area with peaks only
    t = 10;                                     % extra points around min/max
    asHmax = find(asHppm-min(wHvppm)<0)(1);     % minimum ppm -- note axis is reversed!
    asHmin = find(asHppm-max(wHvppm)<0)(1);     % maximum ppm
    asNmin = find(asNppm-min(wNvppm)>0)(1);     % minimum ppm -- note axis is reversed!
    asNmax = find(asNppm-max(wNvppm)>0)(1);     % maximum ppm
    asHmin = max(1,asHmin-t);
    asHmax = min(length(asHppm),asHmax+t);
    asNmin = max(1,asNmin-t);
    asNmax = min(length(asNppm),asNmax+t);
    % define zoomed region
    zoomSpec = Sr(asNmin:asNmax,asHmin:asHmax);  %
    if ispc()
        % install downsample function -- this needs forge installed -- true for Windows
        pkg load signal
        % downsample zoomed spectrum
        Srd1 = downsample(zoomSpec,2);
        Srd2 = downsample(Srd1',2);
        Srd3 = Srd2';
        ax1 = downsample(asHppm(asHmin:asHmax),2);
        ax2 = downsample(asNppm(asNmin:asNmax),2);
        % plot
        mesh(ax1, ax2, Srd3);
    else
        mesh(asHppm(asHmin:asHmax), asNppm(asNmin:asNmax), zoomSpec);
    end
    xlabel('1H (ppm)')
    ylabel('15N (ppm)')
    set(gca,'XDir','reverse')
    set(gca,'YDir','reverse')
    titlestr = sprintf("1H-15N HSQC spectrum of %s (%.1f kDa)\n\n titration point %d", acronymProtein, proteinMass, titrationPoint);
    title(titlestr,"fontweight","bold")
    % warnings to user after plotting
    if strcmp(graphics_toolkit, 'qt') == 1
        if ispc()
            disp("\tBEWARE: the UU PCs and this plot window are not friends.")
            disp("\tBefore continuing do the following")
            disp("\t- in the menu bar of the Figure 3 window, click Tools")
            disp("\t- then click GUI mode (on all axis)")
            disp("\t- then click Disable pan and rotate")
            disp("")
            disp("Do this now before continuing...")
            disp("")
            junk=input("<>","s");
            disp("")
            disp("\tNow you can click the rotate icon in the figure window menu bar to activate rotation.")
            disp("\tClick, hold and drag mouse to rotate the plot.")
        % avoid zooming in to prevent crashes on UU PCs
        %disp("\tYou can click the zoom button in the figure window menu bar to drag-select a zoom region.")
        %disp("\tClick the button with a 1 inside the magnifying glass to go back to the full view.")
        else
            disp("\tClick the rotate icon in the figure window menu bar to activate rotation.")
            disp("\tClick, hold and drag mouse to rotate the plot.")
            disp("\tYou can click the zoom button in the figure window menu bar to drag-select a zoom region.")
            disp("\tClick the button with a 1 inside the magnifying glass to go back to the full view.")
        end
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
end

