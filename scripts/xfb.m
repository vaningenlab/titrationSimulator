% xfb.m
%
% process and visualize 2D spectrum after FID has been simulated
% upon completion ask to do another titration step
% and explain how to adjust contours

% !bug upon redoing processing! 15N dim is not stable??? changes after 1st time!
% SOLVED! never use "i" as iterator, or never use "i" as complex number, or BOTH!!

if exist("McX") == 0
	disp("")
	disp("Oops! First record a FID by typing zg")
	disp("")
else
    process2D;
    plot2D;
    if titrationPoint == 1 && sino < 10
        disp("")
        disp("The signal-to-noise is too low in this spectrum")
        disp("Do one of the following:")
        disp("\t - increase the number of scans (ns) and rerun the HSQC")
        disp("\t   by typing \"eda\" at the command prompt")
        disp("\t - or make a new sample with a higher protein concentration")
        disp("\t   by typing \"makeSample\" at the command prompt")
        disp("\t   note that in this case you need to redo the titration!")
        disp("")
    else
        disp("")
        if titrationPoint == 1
            if showHint == 0
                disp("")
                printf("Check whether you can find all %d peaks back in the spectrum\n", numPeaks)
                disp("Note that sometimes it can happen that peaks overlap.")
                disp("Sometimes the label overlaps with a peak and is not visible")
                disp("In these situations you can zoom in on a peak using \"zoomPeak\".")
                disp("")
                junk=input("<>","s");
                disp("")
                disp("Before we continue with the titration experiment,")
                if easyMode == 3
                    disp("I first have one other assignments and question for you.")
                else
                    disp("I first have two other assignments and questions for you.")
                end
                showHint = 1;
            end
            if easyMode > 2
                    cq = 2;
            elseif easyMode == 2
                    cq = 3;
            else
                    cq = 5;
            end
            if questionAsked(4) == 0 && easyMode < 2
                disp("")
                disp("First, play around a little with the acquisition times and number of scans and investigate how:")
                disp("    - the resolution changes upon changing the 1H and/or 15N acquisition times;")
                disp("      record spectra with very different acq. times in either 1H or 15N dimension.")
                if easyMode == 1
                    disp("      Do this by reducing the acq. time to 0.01 sec.")
                end
                disp("    - how the signal-to-noise changes upon changing the number of scans.")
                disp("      using fixed acq. times settings, vary the number of scans, and evaluate the S/N.")
                if easyMode == 1
                    disp("      Do this by increasing the scans from 8 to 64 and write down the S/N numbers.")
                end
                disp("")
                junk=input("<>","s");
                disp("")
                disp("To do this, type \"eda\" at the command prompt, then update the acquisition times,")
                disp("the number of scans, and then record the spectrum (\"zg\") and process it (\"xfb\")")
                disp("")
                printf("When you think you're ready for the question, type \"question(4)\" at the command prompt.\n")
                disp("")
            elseif questionAsked(cq) == 0
                disp("")
                disp("Now activate the 3D plot of the your HSQC by typing \"coneView\" at the command prompt and")
                disp("compare it to the contourplot:")
                disp("\t - identify each of the peaks in both spectra")
                disp("\t - use these different views of the spectrum to compare the intensities of different peaks")
                peakLabel1 = strcat(aa_string(minS2peak),num2str(minS2peak));
                peakLabel2 = strcat(aa_string(maxS2peak),num2str(maxS2peak));
                printf("\t   Take a good look at peak of residue %s vs. %s\n", peakLabel1, peakLabel2);
                disp("\t - Think about a reason for any differences in peak intensities")
                disp("")
                junk=input("<>","s");
                disp("")
                if length(overlap) > 0 && ( any(overlap == minS2peak) || any(overlap == maxS2peak) )
                    disp("Hmmm, it looks like you have a very complicated case, with some overlapping peaks")
                    disp("Check with your instructor when answering the question")
                    disp("")
                    junk=input("<>","s");
                    disp("")
                end
                disp("The following commands may be useful, each can be issued at the command prompt:")
                disp("\t - edlev        (to change contouring of the spectra)")
                disp("\t - zoomPeak     (to zoom in on a peak in the spectra)")
                disp("\t - zoomFull     (to show full spectrum after zooming in)")
                disp("\t - coneView     (show a 3D mesh plot of current spectrum)")
                disp("")
                printf("When you think you're ready for the question, type \"question(%d)\" at the command prompt.\n",cq)
                disp("")
            elseif questionAsked(cq) == 1
                disp("")
                disp("To add ligand to the sample, type \"titrate\".")
                disp("")
            end
        else
            if peakDissappearCheck < 0.2*sino/120*startFloor/0.05 && beNice == 1
                % checked that 0.2 is good setting default plot, w/ 120 starting sino
                % show contour tip if sino of peak too low
                disp("")
                disp("If you cannot see all peaks, try plotting the contour levels starting closer to the noise level")
                disp("Type \"edlev\" at the command prompt to adjust the contour settings,")
                disp("and adjust the last number to 0.04 or lower")
                disp("Otherwise, just continue with your titration.")
                disp("")
                junk=input("<>","s");
            end
            % could ask dilution question here;
            if easyMode == 1 && pb > 0.7 && questionAsked(7) == 0
                disp("")
                disp("Time for another question...")
                disp("Take a good look at how the peak intensity changes during the titration.")
                disp("You can zoom in on one peak using \"zoomPeak\" or")
                disp("you can extract a 1D slice through one peak using \"showSlices\".")
                disp("If you are ready for the question, type \"question(7)\".")
                disp("")
            else
                % progress bar to show % bound state protein in 5% steps
                percentBound = 100*cConcv(titrationPoint)/pConc;
                progressTitration = round(percentBound/5);
                emptyBits         = 20 - progressTitration;
                disp("          * titration progress bar (in steps of 5%) *")
                disp("       0%                                   100% complete")
                printf("     [")
                for i = 1:progressTitration
                    printf("--")
                end
                printf("%2.0f",round(percentBound/5)*5)
                for i = 1:emptyBits
                    printf("  ")
                end
                printf("]\n")
                disp("")
                disp("")
                disp("Next, type at the command prompt one of the following commands:")
                disp("")
                disp("\t - titrate       (to add more ligand to your sample)")
                disp("\t - report        (print overview of titration steps)")
                disp("\t - calcCSP       (calculate chemical shift perturbations)")
                disp("\t - edlev         (to change contouring of the spectra)")
                disp("\t                 (this will also redraw the peak numbers if you've lost them)")
                disp("\t - listCommands  (show all commands available)")
                %disp("\t - showFID       (to show the free induction decay)")
                %disp("\t - reduceOverlay (reduce the number of spectra in the overlay")
                %disp("\t - showSlices    (show 1D projections for a peak)")
                %disp("\t - zoomPeak      (to zoom in on a peak in the spectra)")
                %disp("\t - zoomFull      (to show full spectrum after zooming in)")
                %disp("\t - coneView      (show a 3D mesh plot of current spectrum)")
                %disp("\t - saveFigure    (save current view of the HSQCs to a PNG file)")
            end
        end
    end
end
