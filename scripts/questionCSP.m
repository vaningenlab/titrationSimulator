% questionCSP.m
% to make sure students perceive this explictly as a question
peakErr = 0;
continueCalcQuestion = "y";
% for safety add check here as well
if titrationPoint < 4
    % user first needs to do at least three additions
    disp("")
    printf("First add some more ligand by typing %s at the command prompt.\n", dispCommand("titrate"))
    disp("")
else % enough titrationPoints
    disp("")
    disp("You will be asked to simply left-click the peak center in the")
    printf("%sfirst (=free) and final (=bound)%s spectrum with the mouse.\n",CYN, WHT)
    disp("")
    disp("This works best if you enlarge the spectrum window as much as possible,")
    disp("but so that you can still see this.");
    if strcmp(graphics_toolkit, 'qt') == 1
        disp("")
        printf("%s", CYN)
        disp("You can zoom in further to the region of the spectrum with all peaks.")
        disp("To do that click the magnifying glass with a 1 in it in the figure window menu bar.")
        disp("Make sure to deactivate the zoom tool when you are done!")
        printf("%s", WHT)
    end
    disp("")
    disp("Do that now, and make sure to activate the spectrum by clicking on title bar.")
    disp("Also make sure that none of the figure window tools are active!")
    if strcmp(graphics_toolkit,"qt") == 1
        % blue on windows, gray on mac
        disp("If the tool is active the background color is slightly gray.")
    end
    disp("")
    showBreak
    disp("")
    disp("Be sure to only click inside the spectrum window.")
    disp("Do not adjust the size of the spectrum window any more.")
    disp("")
    if strcmp(graphics_toolkit, 'qt') == 1
        printf("%s", CYN)
        disp("In few cases the cursor changes to zoom mode by itself, visible as blue plus sign inside a circle.")
        disp("If that happens, first deactivate the zoom mode by clicking zoom button in the figure menu bar.")
        disp("When the cursor is back in selection mode, it shows up as a cursor arrow or as a big white plus sign.")
        printf("%s", WHT)
    elseif strcmp(graphics_toolkit, 'fltk') == 1
        printf("%s", CYN)
        disp("Be sure that the cursor is in selection mode, visible as a normal cursor.")
        disp("Make sure none of the A, P, G, R tools are active!")
        printf("%s", WHT)
    end
    disp("")
    disp("And click slowly!")
    disp("")
    showBreak
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
        peakErrApo = 0; % to check correct apo position
        peakErrBnd = 0; % to check correct bound position
        % pick free state peak, return x y
        disp("")
        peakLabel = strcat(aa_string(p),num2str(p));
        colorSpec = regexprep(colorNamesLong(1,:), '\W', "");
        printf("Pick the center of peak %s in the free spectrum (%s)\n", peakLabel, colorSpec)
        [x_f, y_f, buttons] = ginput(1);
        % ginput is source of problems
        %         v7 after installing Windows and Octave4.4.1 for Windows
        %         mac version does not respond to ginput in CLI mode (gnuplot)
        %         windows version does work in CLI mode (fltk)
        % check whether peak has been picked correctly
        % apo state peak position is in wHvppm / wNvppm vectors
        % ginput reports directly in ppm units
        if abs(x_f - wHvppm(p)) > cspBoxHppm || abs(y_f - wNvppm(p)) > cspBoxNppm
            peakErr=peakErr+1
            peakErrApo = 1
            if peakErr < 4
                disp("")
                disp("Ai, that is too far from the actual peak...")
                disp("For the next time, double check that you are looking at the right peak!")
                disp("Check that you have the correct residue and the free-state spectrum. ")
                disp("")
                showBreak
            else
                disp("")
                disp("There seems to be something going wrong here...")
                disp("You can continue but also decide to retry it.")
                disp("If you want to retry, type Ctrl-C until you see the prompt,")
                printf("set cspTime to 0 (%s) and restart the analysis (%s).\n",dispCommand("cspTime=0"), dispQuestion(cspq))
                disp("Ask your instructor to have a look and help you. ")
                disp("")
                showBreak
            end
            %disp("Try again, type these commands:")
            %disp("\t - edlev(10,1.4,0.1)  (to clear any lines)")
            %disp("\t - calcCSP            (to start the analysis again)")
            disp("")
            %break  -- do not do this anymore 
        end % check bad pick free state
        % pick bound state peak, return x y
        % check whether we have more points than colors:
        tp = titrationPoint;
        if tp <= length(colorNamesLong)
            colorSpec = regexprep(colorNamesLong(tp,:), '\W', "");
        elseif tp <= 2*length(colorNamesLong)
            % wrap around: there are 11 colors, tp 12 will be color 1
            cp = tp - length(colorNamesLong);
            colorSpec = regexprep(colorNamesLong(cp,:), '\W', "");
        elseif tp <= 3*length(colorNamesLong)
            % wrap around 2x: there are 11 colors, tp 12 will be color 1
            cp = tp - 2*length(colorNamesLong);
            colorSpec = regexprep(colorNamesLong(cp,:), '\W', "");
        else
            % wrap around 3x: there are 11 colors, tp 12 will be color 1
            cp = tp - 3*length(colorNamesLong);
            colorSpec = regexprep(colorNamesLong(cp,:), '\W', "");
        end
        printf("Pick the center of peak %s in the bound spectrum (%s) \n", peakLabel, colorSpec)
        [x_b, y_b, buttons] = ginput(1);
        % read the final peakposition from the maximum of the peakStore spectrum
        % this can be different from the final bound state dependend on the saturation level
        % extract 2D FID for peak
        peakFIDX = peakStoreX(:,:,p, tp);
        peakFIDY = peakStoreY(:,:,p, tp);
        % process 2D FID of peak
        SpHX    = processFID(peakFIDX, zfH, 0, 0, 0, 0, swH); % amplitude modulated cosine FID
        SpHY    = processFID(peakFIDY, zfH, 0, 0, 0, 0, swH); % amplitude modulated sine FID
        peakSr  = processFID(SpHX + sqrt(-1)*SpHY, zfN, 0, 0, 0, 0, swN);
        % get peak maximum
        [val, boundPosH] = max(max(peakSr));
        [val, boundPosN] = max(max(peakSr'));
        % above only fails if S/N is insufficient -- which is fair
        if abs(x_b - asHppm(boundPosH)) > cspBoxHppm || abs(y_b - asNppm(boundPosN)) > cspBoxNppm
            peakErr = peakErr + 1;
            peakErrBnd = 1;
            if peakErr < 4
                disp("")
                disp("Ai, you clicked too far from the peak...")
                disp("For the next time, double check that you are looking at the right peak!")
                disp("Check that you have the correct residue and the bound-state spectrum. ")
                disp("")
                showBreak
            else
                disp("")
                disp("There seems to be something going wrong here...")
                disp("You can continue but also decide to retry it.")
                disp("If you want to retry, type Ctrl-C until you the prompt,")
                printf("set cspTime to 0 (%s) and restart the analysis (%s).\n",dispCommand("cspTime=0"), dispQuestion(cspq))
                disp("Ask your instructor to have a look and help you. ")
                disp("")
                showBreak
            end
        end
        % calculate dx dx weighted CSP
        H_CSP = x_b - x_f;
        N_CSP = y_b - y_f;
        CSP(p)   = sqrt(H_CSP^2 + (N_CSP/5)^2);
        % plot line connecting free to bound if CSP > treshold
        line([x_f x_b],[y_f y_b],"linestyle",":", "color", [0.1, 0.1, 0.1])
        %pause(0.5)
        % check result % also if free state has been mis-identified!
        simCSPH = dwHvppm(p);
        simCSPN = dwNvppm(p);
        simCSP(p)  = sqrt(simCSPH^2 + (simCSPN/5)^2);
        % checking absolute value allows swapping free and bound!
        % strict checking for scoring
        % scaling by pb is only valid in fast exchange regime! is maximum difference
        % this may not be true for all peaks, so also allow that
        % correct if CSP_o = [CSP_true*pb CSP_true]; thus CSP_o/CSP_true = pb-1 thus >=pb*0.9 < 1.1
        % also consider peakErr, since CSP is just a number could be accicentally correct
        % so actually both free and bound peak position should be correct within tolerance
        % and final CSP value should be within tolerance
        % zero CSP will give error so 
        if simCSP(p) > 0.2 || simCSP(p) < -0.2
            if CSP(p)/simCSP(p) > pb*0.9 && CSP(p)/simCSP(p) < 1.1 && peakErrApo == 0 && peakErrBnd == 0
                corrCSP(p) = 1;
            else
                errList = [errList p];
                p, CSP(p), simCSP(p), CSP(p)/simCSP(p)
            end
        else
            % simCSP = 0 or small so do more lenient check, boxtolerance is 0.6
            if abs(CSP(p)-simCSP(p)) < 0.1 && peakErrApo == 0 && peakErrBnd == 0
               corrCSP(p) = 1;
            else
                errList = [errList p];
                p, CSP(p), simCSP(p), abs(CSP(p)-simCSP(p))
            end
        end
        % relaxed checking for continuing
        %if abs(CSP(p) - pb*simCSP(p)) < 0.2
        %    corrCSP_easy(p) = 1;
        %end
        cspTime = cspTime + 1;  % number of times this analysis was done.
    end % loop over peaks
    % only continue if max 2 mistakes in easy
    %if (sum(corrCSP_easy) < numPeaks - 2)
    if (sum(corrCSP) < numPeaks - 2)
        disp("")
        disp("Oops, there were too many peak picking mistakes to continue...")
        disp("")
        printf("Restart the analysis by typing %s at the prompt.\n", dispQuestion(cspq))
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
        % not more than 2 mistakes wrt to relaxed check within 20% of actual CSP
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
                CSP
                simCSP
                CSP./simCSP
            end
            score=score+sum(corrCSP)+1;
            questionAsked(cspq)=1;
            cspTime = cspTime +1;
            % show the correct CSPs vectors
            for p=1:9
                % plot line connecting between true free to bound
                newPosH = wHvppm(p) - dwHvppm(p);
                newPosN = wNvppm(p) - dwNvppm(p);
                x_f = wHvppm(p);
                x_b = newPosH;
                y_f = wNvppm(p);
                y_b = newPosN;
                line([x_f x_b],[y_f y_b],"linestyle","-", "color", "m", "linewidth", 1.0)
            end
            disp("The actual CSPs are shown as magenta lines.")
        end
        disp("")
        showBreak
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
        showBreak
        disp("")
        disp("Now you can determine the binding interface residues.")
        printf("Type %s at the prompt.\n", dispQuestion(cspq+1))
        disp("")
    end % check number mistakes actual run
end
