% qfp.m
%

if exist("McH2O") == 0
	disp("")
	disp("Oops! First record a pulse calibration FID by typing zg")
	disp("")
elseif strcmp(expPars,"find90")
	SrH2O = processFID(McH2O, zfH2O, 0, 0, 0, 0, swH2O);
	figure(2)
	plot(asH2O, SrH2O);
	title("1H pulse calibration - find90 - 4xp1", 'fontweight', 'bold')
	xlabel('1H (Hz)')
	ylabel('intensity')

	disp("")
	disp("To continue the calibration, type at the command prompt:")
	disp("")
	disp("\t - p1 = xx      (to change the p1 value)")
	disp("\t - zg           (to record another 1D)")
	disp("\t - qfp          (to look at the spectrum)")
	disp("")	
	disp("When you're satisfied with the pulse calibration, you proceed with recording")
	printf("an HSQC of your protein %s without any ligand.\n", acronymProtein)
	disp("First load the parameters of the HSQC experiment, using the current p1 value, by typing:")
	disp("")
	disp("rpar(\"HSQC\")")
	disp("")
	disp("at the command prompt (with the quotes surrounding HSQC) and hit return.")
	disp("")
elseif strcmp(expPars,"popt")
    SrH2O = processFID(McH2O, zfH2O, 0, 0, 0, 0, swH2O);
    % add zeros here to seperate spectra better
    SrH2O = [ SrH2O' zeros(1,2000)];
    allH2O = [allH2O SrH2O];
end
