% saveFigure.m

disp("")
% save HSQCs
disp("Generating the plot can take some time ....")
figure(2);
%student should make sure him/herself
%can use plot window tool for more appropiate zoom
%plotAll
%zoomFull
% file location:
%     mac: pwd in octave is main dir (inherited from startup dir) while path points to script dir
% windows: saved in pw for mac (inherits startup dir)
% file saved 
if ispc()
    fileName = sprintf("../titr_spec_%s_%s_%d.png", acronymProtein, acronymLigand, titrationPoint);
else
    fileName = sprintf("titr_spec_%s_%s_%d.png", acronymProtein, acronymLigand, titrationPoint);
end
if exist(fileName, "file") == 2
    fileName2 = sprintf("%s.BAK.png", fileName);
    movefile(fileName, fileName2);
    printf("Backing up existing file %s to %s\n", fileName, fileName2);
end
print(fileName, "-dpng");
disp("")
printf("Written %s in directory %s.\n", fileName, pwd)
disp("")
% save binding curve
figure(6)
if ispc()
    fileName = sprintf("../titr_curve_%s_%s_%d.png", acronymProtein, acronymLigand, titrationPoint);
else
    fileName = sprintf("titr_curve_%s_%s_%d.png", acronymProtein, acronymLigand, titrationPoint);
end 
if exist(fileName, "file") == 2
    fileName2 = sprintf("%s.BAK.png", fileName);
    movefile(fileName, fileName2);
    printf("Backing up existing file %s to %s\n", fileName, fileName2);
end
print(fileName, "-dpng");
disp("")
printf("Written %s in directory %s.\n", fileName, pwd)
disp("")

% also save systemInfo to file
if ispc()
    fileName = sprintf("../titr_info_%s_%s_%d.txt", acronymProtein, acronymLigand, titrationPoint);
else
    fileName = sprintf("titr_info_%s_%s_%d.txt", acronymProtein, acronymLigand, titrationPoint);
end 
if exist(fileName, "file") == 2
    fileName2 = sprintf("%s.BAK.txt", fileName);
    movefile(fileName, fileName2);
    printf("Backing up existing file %s to %s\n", fileName, fileName2);
end
fid = fopen(fileName,'w');
fprintf(fid,"\t*** system details ***\n")
fprintf(fid,"\tprotein                      : %s factor %s (%.1f kDa)\n", proteinDescriptor, acronymProtein, proteinMass)
fprintf(fid,"\tligand                       : %s %s (%.1f kDa)\n", ligandDescriptor, acronymLigand, ligandMass)
if affinityValue < 100e-9
    fprintf(fid,"\ttrue dissocation constant    : %.2f nM\n", affinityValue*1e9)
elseif affinityValue < 100e-6
    fprintf(fid,"\ttrue dissocation constant    : %.2f uM\n", affinityValue*1e6)
else
    fprintf(fid,"\ttrue dissocation constant    : %.2f mM\n", affinityValue*1e3)
end
if easyMode >=1 && exist("KD_fit", "var")
    if KD_fit > 1
        fprintf(fid,"\tfitted dissocation constant  : %.2f mM\n", KD_fit)
    elseif KD_fit > 1e-3
        fprintf(fid,"\tfitted dissocation constant  : %.0f uM\n", KD_fit*1e3)
    else
        fprintf(fid,"\tfitted dissocation constant  : %.0f nM\n", KD_fit*1e6)
    end
    fprintf(fid,"\terror in dissocation constant: %.1f %%\n", (KD_fit-affinityValue*1e3)/(affinityValue*1e3)*100)
end
fprintf(fid,"\texchange class               : %d\n", exchangeClass)
fprintf(fid,"\toff-rate                     : %.2f s-1\n", koff)
fprintf(fid,"\ton-rate                      : %.2f 10^6 M-1 s-1\n", koff/affinityValue*1e-6)
if exist("proteinConc", "var")
    if proteinConc < 100e-6
        fprintf(fid,"\tprotein concentration        : %.2f uM\n", proteinConc*1e3)
    else
        fprintf(fid,"\tprotein concentration        : %.2f mM\n", proteinConc)
    end
    fprintf(fid,"\tligand stock                 : %.2f mM\n", ligandStock)
end
if plotPoints > 0
    fprintf(fid,"\tcalibrated p1                 : %.2f us\n", p1)
    fprintf(fid,"\ttrue p1                       : %.2f us\n", trup)
    fprintf(fid,"\ttau INEPT                     : %.2f ms\n", tau*1e3)
    fprintf(fid,"\tacq. time 1H                  : %.3f s\n", atH)
    fprintf(fid,"\tacq. time 15N                 : %.3f s\n", atN)
    fprintf(fid,"\tns                            : %d\n", ns)
end
fprintf(fid, "*** overview of titration steps ***\n")
    if beNice == 1
        fprintf(fid, " %3s \t %3s \t %6s %8s %8s %8s\n", " # ", "clr", "molar ", "protein", "ligand", "bound")
        fprintf(fid," %3s \t %3s \t %6s %8s %8s %8s\n", "   ", "   ", "equiv.", "conc.  ", "conc. ", "protein")
        fprintf(fid," %3s \t %3s \t %6s %8s %8s %8s\n\n", "   ", "   ", "      ", " (mM)  ", " (mM) ", "(fraction)")
        for s=1:titrationPoint
            colorIdx = mod(s-1,length(colorPlot))+1;
            fprintf(fid," %3d \t %3s \t %6.2f %8.3f %8.3f %8.3f\n", s, colorNames(colorIdx,:), molEqv(s), pConcv(s), lConcv(s), cConcv(s)/pConcv(s))
        end
    else
        fprintf(fid," %3s \t %3s \t %6s %8s %8s\n", " # ", "clr", "molar ", "protein", "ligand")
        fprintf(fid," %3s \t %3s \t %6s %8s %8s\n", "   ", "   ", "equiv.", "conc.  ", "conc. ")
        fprintf(fid," %3s \t %3s \t %6s %8s %8s\n\n", "   ", "   ", "      ", " (mM)  ", " (mM) ")
        for s=2:titrationPoint
            colorIdx = mod(s-1,length(colorPlot))+1
            fprintf(fid," %3d \t %3s \t %6.2f %8.3f %8.3f\n", s, colorNames(colorIdx,:), molEqv(s-1), pConcv(s-1), lConcv(s-1))
        end
    end
if easyMode == 1
    fprintf(fid, "Your final score          : %d out of 10 points\n", finalScore)
elseif easyMode < 3
    fprintf(fid, "Your final score          : %d out of %d points\n", score, numQuestions*questionPoints+10)
else
    fprintf(fid, "Your final score          : %d out of %d points\n", score, numQuestions*questionPoints)
end

fclose(fid)


disp("Send these figures, together with the output from the \"systemInfo\" command to:")
disp("")
printf("        %s\n", instructorMail)
disp("")
disp("Check the output above to see in which directory the figures are saved!")
disp("")
disp("Once you have sent the figure and output you can close this program by typing \"goodbye\"")


