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
else % enough titrationPoints
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
    end % not saturated
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
        disp("")
        disp("It can help to make spectrum window larger.")
        disp("Make sure the zoom tool and the rotate tool are NOT activated")
        if strcmp(graphics_toolkit,"qt") == 1
            % blue on windows, gray on mac
            disp("If the tool is active the background color is slightly gray.")
        end
        disp("")
        disp("If you cannot see the peak labels well, issue \"plotAll\" at the command prompt.")
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
            disp("Be sure to enlarge the spectrum window and zoom in on the region with all peaks.")
            disp("")
        end
        disp("Other commands that are useful:")
        disp("\t - zoomPeak     (to zoom in on a peak)")
        disp("\t - zoomFull     (to go back to full view)")
        disp("\t - edlev        (to change the countouring)")
        disp("\t - plotAll      (to replot all spectra and put labels on top")
        disp("")
        junk=input("<>","s");
        disp("")
        disp("Now try to figure out the free and bound positions for each residue, by tracking how each peak moves.")
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
        disp("Do that now, and make sure to activate the spectrum by clicking on title bar.")
        disp("Also make sure that none of the figure window tools are active!")
        if strcmp(graphics_toolkit, 'qt') == 1
            disp("")
            disp("You can zoom in further to the region of the spectrum with all peaks.")
            disp("To do that click the magnifying glass with a 1 in it in the figure window menu bar.")
            disp("Make sure to deactivate the zoom tool when you are done!")
        end
        disp("")
        junk=input("<>","s");
        disp("")
        disp("Be sure to only click inside the spectrum window.")
        disp("Do not adjust the size of the spectrum window any more.")
        disp("")
        if strcmp(graphics_toolkit, 'qt') == 1
            disp("In few cases the cursor changes to zoom mode by itself, visible as blue plus sign inside a circle.")
            disp("If that happens, first deactivate the zoom mode by clicking zoom button in the figure menu bar.")
            disp("When the cursor is back in selection mode, it shows up as a cursor arrow or as a big white plus sign.")
        elseif strcmp(graphics_toolkit, 'fltk') == 1
            disp("Be sure that the cursor is in selection mode, visible as a normal cursor.")
            disp("Make sure none of the A, P, G, R tools are active!")
        end
        disp("")
        disp("And click slowly!")
        disp("")
        junk=input("<>","s");
        disp("")
        % bring spectrum window forward
        figure(2)
        CSP = zeros(1,numPeaks);
        corrCSP = zeros(1,numPeaks); % to store correctness for scoring
        corrCSP_easy = zeros(1,numPeaks); % to store correctness for continuing
        cspBoxH = 200;	% was 50 initially, increased it for more tolerance in picking
        cspBoxN = 100;	% and to alleviate problems with bound state, 80% saturation could be 200 Hz off
        cspBoxHppm = 0.12;
        cspBoxNppm = 0.6;
        % for each peak 1:9
        simCSP = zeros(1,numPeaks);
        errList =[];
        for p=1:numPeaks
            % pick free state peak, return x y
            disp("")
            peakLabel = strcat(aa_string(p),num2str(p));
            printf("Pick the center of peak %s in the free spectrum (%s)\n", peakLabel, colorNamesLong(1,:))
            [x_f, y_f, buttons] = ginput(1);
            % ginput is source of problems
            %         v7 after installing Windows and Octave4.4.1 for Windows
            %         mac version does not respond to ginput in CLI mode (gnuplot)
            %         windows version does work in CLI mode (fltk)
            % check whether peak has been picked correctly
            % actualPosH = centerHppm - (wHvppm(p)-centerHppm);
            % actualPosN = centerNppm - (wNvppm(p)-centerNppm);
            % ginput reports directly in ppm units
            if abs(x_f - wHvppm(p)) > cspBoxHppm || abs(y_f - wNvppm(p)) > cspBoxNppm
                peakErr=peakErr+1;
                if peakErr < 3
                    disp("")
                    disp("Ai, that is too far from the actual peak...")
                    disp("For the next time, double check that you are looking at the right peak!")
                    disp("Check that you have the correct residue and the free-state spectrum. ")
                    disp("")
                    junk=input("<>","s");
                else
                    disp("")
                    disp("There seems to be something going wrong here...")
                    disp("You can continue but also decide to retry it.")
                    disp("If you want to retry, type Ctrl-C until you the prompt, set cspTime to 0 and restart the analysis.")
                    disp("Ask your instructor to have a look and help you. ")
                    disp("")
                    junk=input("<>","s");
                end
                %disp("Try again, type these commands:")
                %disp("\t - edlev(10,1.4,0.1)  (to clear any lines)")
                %disp("\t - calcCSP            (to start the analysis again)")
                disp("")
                %break  -- do not do this anymore 
            end % check bad pick free state
            % pick bound state peak, return x y
            printf("Pick the center of peak %s in the bound spectrum (%s) \n", peakLabel, colorNamesLong(titrationPoint,:))
            [x_b, y_b, buttons] = ginput(1);
            % IMPORTANT! this check only works when (enough) fully bound!
            % need to have approximate peak positions in final spectrum
            % which should be equal to eigenvalue of largest eigenvector?
            if checkBound == 1
                %newPosH = actualPosH - dwHvppm(p);
                %newPosN = actualPosN - dwNvppm(p);
                % fix for Windows / FLTK / CLI 
                newPosH = wHvppm(p) - dwHvppm(p);
                newPosN = wNvppm(p) - dwNvppm(p);
                if abs(x_b - newPosH) > cspBoxHppm || abs(y_b - newPosN) > cspBoxNppm
                    peakErr=peakErr+1;
                    if peakErr < 3
                        disp("")
                        disp("Ai, you clicked too far from the peak...")
                        disp("For the next time, double check that you are looking at the right peak!")
                        disp("Check that you have the correct residue and the bound-state spectrum. ")
                        disp("")
                        junk=input("<>","s");
                    else
                        disp("")
                        disp("There seems to be something going wrong here...")
                        disp("You can continue but also decide to retry it.")
                        disp("If you want to retry, type Ctrl-C until you the prompt, set cspTime to 0 and restart the analysis.")
                        disp("Ask your instructor to have a look and help you. ")
                        disp("")
                        junk=input("<>","s");
                    end
                end
            end % check bound pick
            % calculate dx dx weighted CSP
            H_CSP = x_b - x_f;
            N_CSP = y_b - y_f;
            CSP(p)   = sqrt(H_CSP^2 + (N_CSP/5)^2);
            % plot line connecting free to bound if CSP > treshold
            line([x_f x_b],[y_f y_b],"linestyle",":", "color", [0.1, 0.1, 0.1])
            %pause(0.5)
            % check result % also if free state has been mis-identified!
            simCSPH = dwHvppm(p);
            simCSPN = dwHvppm(p);
            simCSP(p)  = sqrt(simCSPH^2 + (simCSPN/5)^2);
            % checking absolute value allows swapping free and bound!
            % strict checking for scoring
            % scaling by pb is only valid in fast exchange regime!
            % this may not be true for all peaks, so also allow that
            if abs(CSP(p) - pb*simCSP(p)) < 0.1
                corrCSP(p) = 1;
            elseif abs(CSP(p) - simCSP(p)) < 0.1
                corrCSP(p) = 1;
            else
                errList = [errList p];
            end
            % relaxed checking for continuing
            if abs(CSP(p) - pb*simCSP(p)) < 0.2
                corrCSP_easy(p) = 1;
            end
            cspTime = cspTime + 1;  % number of times this analysis was done.
        end % loop over peaks
        % only continue if max 2 mistakes in easy
        if (sum(corrCSP_easy) < numPeaks - 2)
            disp("")
            disp("Oops, there were too many peak picking mistakes to continue...")
            disp("")
            disp("Restart the analysis by typing \"calcCSP\" at the prompt.")
            disp("Ask your instructor to have a look.")
            disp("")
            disp("Other commands that are helpful:")
            disp("\t - edlev(10,1.4,0.1)  (to clear any lines)")
            disp("\t - calcCSP            (to start the analysis again)")
            disp("\t - zoomPeak           (to zoom in on a peak)")
            disp("\t - zoomFull           (to go back to full view)")
            disp("")
            cspTime = 0;
        else
            % not more than 2 mistakes
            disp("")
            disp("")
            printf("Cool! You identified %d peak shifts correctly.\n", sum(corrCSP));
            if questionAsked(cspq) == 0
                % only get points on first try
                printf("So you get %d points.\n", sum(corrCSP)+1);
                if sum(corrCSP) == numPeaks
                    disp("Awesome, really good job!")
                else
                    % some feedback on which were wrong?
                    disp("")
                    disp("The computer is very picky today.")
                    printf("Something went wrong for peak(s): ")
                    for e = 1:length(errList)
                        p = errList(e);
                        peakLabel = strcat(aa_string(p),num2str(p));
                        printf(" %s ", peakLabel)
                    end
                    printf("\n")
                end
                score=score+sum(corrCSP)+1;
                questionAsked(cspq)=1;
                cspTime = cspTime +1;
            end
            disp("")
            junk=input("<>","s");
            disp("")
            disp("Figure 5 now shows for each residue the chemical shift perturbation.")
            disp("The peak displacements in the 1H and 15N dimension are combined into one number.")
            disp("")
            figure(5)
            hold off 
            bar(CSP)
            xlabel("residue number")
            ylabel("weighted chemical shift perturbation (ppm)")
            title("CSP analysis","fontweight","bold")
            disp("Time for another question:")
            disp("")
            junk=input("<>","s");
            disp("")
            % ask question on interpretation when ready and only if not done before!
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
            [ sss, iii ] = sort(simCSP);
            % sometimes a fourth residue is actually close, so include 9-3 = 6,7,8,9
            if sss(numPeaks-numBig+1) - sss(numPeaks-numBig) < 0.1
                truList = iii(numPeaks-numBig:numPeaks); 
            else
                truList = iii(numPeaks-numBig+1:numPeaks);
            end
            interfaceScore=1;
            numCorrect=0;
            disp("")
            disp("Checking your answer ....")
            for p = 1:numBig
                resPresent = find((truList - str2num(resList2(p)))==0);
                if isempty(resPresent)
                    disp("")
                    printf("Residue %s is not correct.\n", resList2(p));
                    disp("Maybe something went wrong when picking this peak.")
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
        end % check number mistakes actual run
    end % intro or actual run
end % check enough titrationPoints
