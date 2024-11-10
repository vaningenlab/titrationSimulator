% restoreCSP.m

disp("")
disp("Figure 5 shows for each residue the chemical shift perturbation.")
disp("The peak displacements in the 1H and 15N dimension are combined into one number.")
disp("")
figure(5)
hold off 
bar(CSP)
xlabel("residue number")
ylabel("weighted chemical shift perturbation (ppm)")
title("CSP analysis","fontweight","bold")
disp("")

