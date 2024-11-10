% questionCSP.m
% to make sure students perceive this explictly as a question
peakErr = 0;
continueCalcQuestion = "y";
checkBound = 1;
% set correct question number for binding interface = cspq+1
if easyMode == 1
    cspq = 8;
elseif easyMode == 2
    cspq = 5;
else
    cspq = 4;
end
% for safety add check here as well
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
    disp("")
    disp("You will be asked to simply left-click the peak center in the")
    disp("first (=free) and final (=bound) spectrum with the mouse.")
    disp("")
    disp("This works best if you enlarge the spectrum window as much as possible,")
    disp("but so that you can still see this.");
    if strcmp(graphics_toolkit, 'qt') == 1
        disp("")
        disp("You can zoom in further to the region of the spectrum with all peaks.")
        disp("To do that click the magnifying glass with a 1 in it in the figure window menu bar.")
        disp("Make sure to deactivate the zoom tool when you are done!")
    end
    disp("")
    disp("Do that now, and make sure to activate the spectrum by clicking on title bar.")
    disp("Also make sure that none of the figure window tools are active!")
    if strcmp(graphics_toolkit,"qt") == 1
        % blue on windows, gray on mac
        disp("If the tool is active the background color is slightly gray.")
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
    cspBoxH = 200;  % was 50 initially, increased it for more tolerance in picking
    cspBoxN = 100;  % and to alleviate problems with bound state, 80% saturation could be 200 Hz off
    cspBoxHppm = 0.12;
    cspBoxNppm = 0.6;
    % for each peak 1:9
    simCSP = zeros(1,numPeaks);
    errList =[];
    for p=1:numPeaks
        % pick free state peak, return x y
        disp("")
        peakLabel = strcat(aa_string(p),num2str(p));
        printf("Pick the center of peak %s in the free spectrum (%s)\n", peakLabel, colorNamesLong(1,1:length(colorNamesLong(1,:)-1)))
        [x_f, y_f, buttons] = ginput(1);
        % ginput is source of problems
        %         v7 after installing Windows and Octave4.4.1 for Windows
        %         mac version does not respond to ginput in CLI mode (gnuplot)
        %         windows version does work in CLI mode (fltk)
        % check whether peak has been picked correctly
        % actualPosH = centerHppm - (wHvppm(p)-centerHppm);
        % actualPosN = centerNppm - (wNvppm(p)-centerNppm);
        % ginput reports directly in ppm units
        % hitting will also count as input but 
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
                disp("If you want to retry, type Ctrl-C until you see the prompt, set cspTime to 0 and restart the analysis.")
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
        % check whether we have more points than colors:
        if tp <= length(colorNamesLong)
            printf("Pick the center of peak %s in the bound spectrum (%s) \n", peakLabel, colorNamesLong(titrationPoint,1:length(colorNamesLong(titrationPoint,:)-1)))
        elseif tp <= 2*length(colorNamesLong)
            % wrap around: there are 11 colors, tp 12 will be color 1
            cp = tp - length(colorNamesLong);
            printf("Pick the center of peak %s in the bound spectrum (%s) \n", peakLabel, colorNamesLong(cp,1:length(colorNamesLong(cp,:)-1)))
        elseif tp <= 3*length(colorNamesLong)
            % wrap around 2x: there are 11 colors, tp 12 will be color 1
            cp = tp - 2*length(colorNamesLong);
            printf("Pick the center of peak %s in the bound spectrum (%s) \n", peakLabel, colorNamesLong(cp,1:length(colorNamesLong(cp,:)-1)))
        else
            % wrap around 3x: there are 11 colors, tp 12 will be color 1
            cp = tp - 3*length(colorNamesLong);
            printf("Pick the center of peak %s in the bound spectrum (%s) \n", peakLabel, colorNamesLong(cp,1:length(colorNamesLong(cp,:)-1)))
        end
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
        printf("Restart the analysis by typing \"question(%d)\" at the prompt.\n", cspq)
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
        junk=input("<>","s");
        disp("")
        disp("Now you can determine the binding interface residues.")
        printf("Type \"question(%d)\" at the prompt.\n", cspq+1)
        disp("")
    end % check number mistakes actual run
end
