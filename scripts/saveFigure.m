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

disp("Send these figures, together with the output from the \"systemInfo\" command to:")
disp("")
printf("        %s\n", instructorMail)
disp("")
disp("Check the output above to see in which directory the figures are saved!")
disp("")
disp("Once you have sent the figure and output you can close this program by typing \"goodbye\"")


