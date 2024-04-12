% report.m

if plotPoints > 1
    disp("")
    printf("%s protein %s (%.1f kDa) titrated with %s %s (%.1f kDa)\n", ...
    proteinDescriptor, acronymProtein, proteinMass, ...
    ligandDescriptor, acronymLigand, ligandMass);
    disp("")
    disp("*** overview of titration steps ***")
    disp("")
    if beNice == 1
        printf(" %3s \t %3s \t %6s %8s %8s %8s\n", " # ", "clr", "molar ", "protein", "ligand", "bound")
        printf(" %3s \t %3s \t %6s %8s %8s %8s\n", "   ", "   ", "equiv.", "conc.  ", "conc. ", "protein")
        printf(" %3s \t %3s \t %6s %8s %8s %8s\n\n", "   ", "   ", "      ", " (mM)  ", " (mM) ", "(fraction)")
        for s=1:titrationPoint
            colorIdx = mod(s-1,length(colorPlot))+1;
            printf(" %3d \t %3s \t %6.2f %8.3f %8.3f %8.3f\n", s, colorNames(colorIdx,:), molEqv(s), pConcv(s), lConcv(s), cConcv(s)/pConcv(s))
        end
    else
        printf(" %3s \t %3s \t %6s %8s %8s\n", " # ", "clr", "molar ", "protein", "ligand")
        printf(" %3s \t %3s \t %6s %8s %8s\n", "   ", "   ", "equiv.", "conc.  ", "conc. ")
        printf(" %3s \t %3s \t %6s %8s %8s\n\n", "   ", "   ", "      ", " (mM)  ", " (mM) ")
        for s=2:titrationPoint
            colorIdx = mod(s-1,length(colorPlot))+1
            printf(" %3d \t %3s \t %6.2f %8.3f %8.3f\n", s, colorNames(colorIdx,:), molEqv(s-1), pConcv(s-1), lConcv(s-1))
        end
    end
    disp("")
%    disp("Colors (clr): k= black; r=red; m=magenta; b=blue; g=green; y=yellow; c=cyan")
    disp("Colors (clr): bk=black; rd=red ; ma=magenta; or=orange; yl=yellow; gr=green")
    disp("              cy=cyan ; bl=blue; pu=purple;  ol=olive;  tl=teal")
    disp("")
elseif titrationPoint == 2
    % apparently something was added but not recorded/plotted yet
    disp("")
    disp("First record and plot the HSQC spectrum by typing \"zg\", then \"xfb\".")
    disp("")
else
    disp("")
    disp("First do a titration by typing titrate and recording a new HSQC spectrum.")
    disp("")

end
