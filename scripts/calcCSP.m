% calcCSP.m

% upon finishing the titration

% first some hints how to look at it. right-click to zoom, draging reactangle
% return by zoomFull
% typically 3 that move big time, 3 that don't move and 23 with small move
% if ready then run it gain.

% easyMode = 1 : this is question 8+9
% easyMode = 2 : this is question 5+6
% easyMode = 3 : this is question 4+5


continueCalcQuestion = "y";
peakErr = 0;
checkBound = 1;
% set correct question number
if easyMode == 1
    cspq = 8;
elseif easyMode == 2
    cspq = 5;
else
    cspq = 4;
end
if questionAsked(cspq) == 1
    disp("")
    disp("You already did this analysis.")
    disp("You can do it again but you won't get points for it...")
    disp("")
    junk=input("<>","s");
    disp("")
end
if titrationPoint <= 2
    % user first needs to do at least two additions
    disp("")
    disp("First add some more ligand by typing \"titrate\" at the command prompt.")
    disp("")
else
    if pb < 0.8 && beNice == 1
        % warning if still far from saturation
        % should be possible to continue
        disp("")
        disp("Try adding more ligand to your protein.")
        disp("It looks like you're not done yet.")
        if affinityValue*1e3 < proteinConc && molEq < 1.5
        % check whether plateau has been reached in particular for high affinity binders
            disp("")
            disp("Even though the affinity is rather high, and your protein is nearly completely bound to ligand,")
            disp("it is better to record an additional point to measure the binding plateau.")
            disp("Type \"report\" to see how far you are in the titration.")
            disp("Type \"titrate\" to add more ligand, increase to at least 1.5 equivalents of ligand.")
        end
        disp("")
        disp("Continue anyway, or do first another \"titrate\".")
        continueCalcQuestion = input("Do you want to continue with the perturbation analysis? y/n: ","s");
        if continueCalcQuestion != "n" && continueCalcQuestion != "y"
            continueCalcQuestion = input("Please type y if you want to continue with analyis:","s");
            if continueCalcQuestion != "n" && continueCalcQuestion != "y"
                continueCalcQuestion = "n";
            end
        end
        if continueCalcQuestion == "y"
            % bound state is not reached so no checks on bound-state peak positions
            checkBound = 0;
        end
    end
    if continueCalcQuestion == "y" && calcCSPintro == 1
        % give intro how to use it
        clc
        disp("*** Chemical shift perturbation analysis *** ")
        disp("")
        printf("QUESTION %d.", cspq)
        disp("")
        disp("Great, you're ready for the first objective,")
        disp("that is identification of the binding interface.")
        disp("")
        junk=input("<>","s");
        disp("")
        disp("This is done by a chemical shift perturbation analysis,")
        disp("which is simply evaluating which peak experienced the largest change in chemical shift.")
        disp("So the first step is to identify which peak shifts where.")
        disp("")
        disp("To do this, first a hint:")
        printf("\t - typically (in this simulated experiment) there are %d peaks that don't move,\n", numSmall)
        printf("\t   %d that move a little and %d that move a big distance.\n", numMed, numBig)
        disp("")
        disp("Depending on the exchange regime it may be easy or hard to")
        disp("see where the peaks move to.")
        if max(abs(dwHv./(2*koff))) > 2 || max(abs(dwNv./(2*koff))) > 2
            disp("Even in slow/intermediate exchange, there are usually small shifts visible")
            disp("at the start and end of the titration that you can use")
            disp("to track the direction that the peaks move.")
            disp("You may have to change the contouring of the spectra to see closer to the noise level")
        end
        disp("")
        junk=input("<>","s");
        disp("")
        disp("Look carefully at each peak to identify where they go.")
        disp("Make sure you have the whole spectrum with all peaks visible.")
        disp("If you cannot see the peak labels well, issue \"edlev\" at the command prompt.")
        if titrationPoint > maxSpectra % have set this to be more than 15
            disp("Since you have many overlaid spectra , first simplify this using")
            disp("the \"reduceOverlay\" command.")
        end
        if ligandClass == 1 && koff < 5000 && beNice == 1
                disp("")
                disp("If you cannot see all peaks, try plotting the contourlevels starting closer to the noise level")
                disp("Type \"edlev\" at the command prompt to adjust the contour settings,")
                disp("and adjust the last number to 0.05 or lower")
                disp("")
                junk=input("<>","s");
        end
        if length(overlap) > 0 && ( any(overlap == minS2peak) || any(overlap == maxS2peak) )
            disp("")
            disp("Hmmm, it looks like you have a very complicated case, with some overlapping peaks")
            disp("Maybe check with your instructor when answering the question.")
            disp("Be sure to maximize the spectrum window and zoom in on the region with all peaks.")
            disp("")
        end
        disp("Other commands that are useful:")
        disp("\t - zoomPeak     (to zoom in on a peak)")
        disp("\t - zoomFull     (to go back to full view)")
        disp("\t - edlev        (to change the countouring)")
        disp("\t - plotAll      (to replot all spectra and put label on top")
        disp("")
        junk=input("<>","s");
        disp("")
        disp("Now try to figure out the free and bound positions for each residue, by tracking how eeach peak moves.")
        disp("When you're ready issue \"calcCSP\" again to do the analysis.")
        disp("")
        calcCSPintro = 0;
    elseif continueCalcQuestion == "y" && calcCSPintro == 0
        disp("")
        disp("You will be asked to simply left-click the peak center in the")
        disp("first (=free) and final (=bound) spectrum with the mouse.")
        disp("")
        disp("This works best if you enlarge the spectrum window as much as possible,")
        disp("but so that you can still see this.");
        if strcmp(graphics_toolkit, 'qt') == 1
            disp("")
            disp("Then zoom in to the region of the spectrum with all peaks.")
            disp("To do that click the magnifying glass with a 1 in it in the figure window menu bar.")
        end
        disp("Do that now, and make sure to activate the spectrum by clicking on title bar.")
        disp("Also make sure that none of the figure window tools are active!")
        disp("")
        junk=input("<>","s");
        disp("")
        disp("Be sure to only click inside the spectrum window.")
        disp("Do not adjust the size of the spectrum window any more.")
        disp("")
        if strcmp(graphics_toolkit, 'qt') == 1
            disp("Be sure that the cursor is in selection mode, visible as big white plus sign.")
            disp("Sometimes the cursor changes to zoom mode by itself, visible as blue plus sign inside a circle.")
            disp("If that happens, first deactivate the zoom mode by clicking zoom button in the figure menu bar.")
            disp("When the cursor is back in selection mode is shows up as a big white plus sign.")
            disp("It could be that it only shows up like that after proceeding.")
        elseif strcmp(graphics_toolkit, 'fltk') == 1
            disp("Be sure that the cursor is in selection mode, visible as a normal cursor.")
            disp("Make sure not of the A, P, G, R tools are active!")
        end
        disp("")
        disp("And click slowly!")
        disp("")
        junk=input("<>","s");
        disp("")
        cspTime = cspTime + 1;  % number of times this analysis was done.
        % bring spectrum window forward
        figure(2)
        CSP = zeros(1,numPeaks);
        corrCSP = ones(1,numPeaks); % to store correctness
        cspBoxH = 200;	% was 50 initially, increased it for more tolerance in picking
        cspBoxN = 100;	% and to alleviate problems with bound state, 80% saturation could be 200 Hz off
        cspBoxHppm = 0.15;
        cspBoxNppm = 0.75;
        % for each peak 1:9
        for p=1:numPeaks
            % pick free state peak, return x y
            disp("")
            peakLabel = strcat(aa_string(p),num2str(p));
            printf("Pick the center of peak %s in the free spectrum\n", peakLabel)
            [x_f, y_f, buttons] = ginput(1);
            % ginput is source of problems
            % v7 after installing Windows and Octave4.4.1 for Windows
            % mac version does not respond to ginput in CLI mode (gnuplot)
            % windows version does work in CLI mode (fltk)
            % check whether peak has been picked correctly
            if ppmaxis == 1
                % actualPosH = centerHppm - (wHvppm(p)-centerHppm);
                % actualPosN = centerNppm - (wNvppm(p)-centerNppm);
                % in Windows / FLTK ginput reports directly in ppm units
                % if abs(x_f - actualPosH) > cspBoxHppm || abs(y_f - actualPosN) > cspBoxNppm
                % still need to check behaviour in windows GUI mode (qt), mac GUI (qt)
                if abs(x_f - wHvppm(p)) > cspBoxHppm || abs(y_f - wNvppm(p)) > cspBoxNppm
                    disp("That went wrong...")
                    disp("Try again, type these commands:")
                    disp("\t - edlev(10,1.4,0.1)  (to clear any lines)")
                    disp("\t - calcCSP            (to start the analysis again)")
                    disp("")
                    peakErr=1;
                    break
                end
            else
                if abs(x_f - wHv(p)/(2*my_pi)) > cspBoxH || abs(y_f - wNv(p)/(2*my_pi)) > cspBoxN
                    disp("That went wrong...")
                    disp("Try again, type these commands:")
                    disp("\t - edlev(10,1.4,0.1)  (to clear any lines)")
                    disp("\t - calcCSP            (to start the analysis again)")
                    disp("")
                    peakErr=1;
                    break
                end
            end
            % pick bound state peak, return x y
            printf("Pick the center of peak %s in the bound spectrum\n", peakLabel)
            [x_b, y_b, buttons] = ginput(1);
            % IMPORTANT! this check only works when fully bound!
            % need to have approximate peak positions in final spectrum
            % which should be equal to eigenvalue of largest eigenvector?
            if checkBound == 1
                if ppmaxis == 1
                    %newPosH = actualPosH - dwHvppm(p);
                    %newPosN = actualPosN - dwNvppm(p);
                    % fix for Windows / FLTK / CLI 
                    newPosH = wHvppm(p) - dwHvppm(p);
                    newPosN = wNvppm(p) - dwNvppm(p);
                    if abs(x_b - newPosH) > cspBoxHppm || abs(y_b - newPosN) > cspBoxNppm
                        corrCSP(p) = 0;
                    end
                else
                    if abs(x_b - (wHv(p)+dwHv(p))/(2*my_pi)) > cspBoxH || abs(y_b - (wNv(p)+dwNv(p))/(2*my_pi)) > cspBoxN
                        corrCSP(p) = 0;
                    end
                end
            end
            % calculate dx dx weighted CSP
            H_CSP = x_b - x_f;
            N_CSP = y_b - y_f;
            if ppmaxis == 1
                % scale 15N ppm by factor 5 (factor of spectral width)
                CSP(p)   = sqrt(H_CSP^2 + (N_CSP/5)^2);
            else
                % axis is already in Hz
                CSP(p)   = sqrt(H_CSP^2 + N_CSP^2);
            end
            % plot line connecting free to bound if CSP > treshold
            line([x_f x_b],[y_f y_b],"linestyle",":", "color", [0.1, 0.1, 0.1])
            %pause(0.5)
        end
        % check result!
        if peakErr == 0
            disp("")
            printf("You identified %d peak shifts correctly.\n", sum(corrCSP));
            if questionAsked(cspq) == 0
                % only get points on first try
                printf("So you get %d points.\n", sum(corrCSP)+1);
                if sum(corrCSP) == numPeaks
                    disp("Awesome, good job!")
                end
                score=score+sum(corrCSP)+1;
                questionAsked(cspq)=1;
                cspTime = cspTime +1;
            end
            for p=1:numPeaks
                if corrCSP(p) == 0
                    peakLabel = strcat(aa_string(p),num2str(p));
                    printf("Peak %s was not properly assigned in the bound state.\n", peakLabel)
                end
            end
            disp("")
            junk=input("<>","s");
            % ask question on interpretation when ready and only if not done before!
            % allow for 2 mistakes
            if (sum(corrCSP) >= numPeaks - 2)
                figure(5)
                bar(CSP)
                xlabel("residue number")
                if ppmaxis == 1
                    ylabel("weighted chemical shift perturbation (ppm)")
                else
                    ylabel("peak displacement (Hz)")
                end
                title("CSP analysis","fontweight","bold")
                disp("")
                printf("QUESTION %d.\n", cspq+1)
                disp("")
                printf("Which %d residues are likely in the binding interface?\n", numBig)
                disp("Enter their residue numbers (number only!) separated by spaces below.")
                disp("")
                resList1 = input("Interface peaks are: ","s");
                justNumbers = regexprep(resList1, '\D',"");
                if length(justNumbers) != numBig
                    disp("Please enter a sequence of 3 residue numbers as digits, e.g. 4 5 6")
                    disp("")
                    resList1 = input("Interface residues are: ","s");
                    justNumbers = regexprep(resList1, '\D',"");
                    if length(justNumbers) == 0
                        disp("I give up.... I will take residues 1, 2 and 3 as your answer.")
                        disp("")
                        resList1 = "1 2 3";
                        justNumbers = regexprep(resList1, '\D',"");
                        junk=input("<>","s");
                        disp("")
                    elseif length(justNumbers) != numBig
                        disp("OK, I'll see what I can do...")
                    end
                end
                resList2 = justNumbers(1:numBig); % a simple string of numbers (first three of input)
                if ppmaxis == 1
                    truCSP = sqrt((dwNvppm./(5)).^2+(dwHvppm).^2);
                else
                    truCSP = sqrt((dwNvppm./(2*my_pi)).^2+(dwHv./(2*my_pi)).^2);
                end
                [ sss, iii ] = sort(truCSP);
                % sometimes a fourth residue is actually close, so include 9-3 = 6,7,8,9
                truList = iii(numPeaks-numBig:numPeaks);
                interfaceScore=1;
                numCorrect=0;
                for p = 1:numBig
                    resPresent = find((truList - str2num(resList2(p)))==0);
                    if isempty(resPresent)
                        printf("Residue %s is not correct.\n", resList2(p));
                    else
                        interfaceScore = interfaceScore +3;
                        numCorrect = numCorrect +1;
                    end
                end
                disp("")
                printf("Alright, you identified %d out 3 residues correctly.\n", numCorrect);
                if questionAsked(cspq+1) == 0
                    score = score + interfaceScore;
                    printf("You get %d points and now have %d points in total.\n", interfaceScore, score);
                    questionAsked(cspq+1)=1;
                end
                disp("")
                % cue student to do final analysis if indeed saturated/ or if done
                % that is per residue exchange regime and estimates
                disp("")
                disp("Now you're ready for the final questions.")
                disp("")
                junk=input("<>","s");
                clc
                disp("")
                if easyMode == 0
                    disp("QUESTION 9.")
                    disp("Classify for each of the shifting peaks whether it is in slow/intermediate/fast")
                    disp("exchange in the 1H dimension.")
                    disp("Use the command \"showSlices\" to extract 1D slices in the 1H dimension.")
                    disp("Use these views to classify the exchange regime.")
                    disp("When you're ready to answer the question, type \"question(9)\".");
                else
                    disp("Use the command \"getKD\" to extract a bindingcurve and dissociation constant.")
                end
                disp("")
            else
                disp("")
                disp("To redo the CSP analysis, type these commands:")
                disp("\t - edlev(10,1.4,0.1)  (to clear any lines)")
                disp("\t - calcCSP            (to start the analysis again)")
                disp("\t - zoomPeak           (to zoom in on a peak)")
                disp("\t - zoomFull           (to go back to full view)")
                disp("")
                disp("Otherwise continue with your titration (titrate) or go the next step (getKD)")
                disp("")
            end
        end
    end
end
