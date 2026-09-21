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
    showBreak
    disp("")
end
if titrationPoint <= 4 && pb > 0.8
    % too fast
    disp("")
    disp("Wow you were bit too eager in adding ligand...")
    disp("Seems like you added too much in one of the steps.")
    disp("")
    printf("Best to start over, by making a new sample (%s)\n", dispCommand("makeSample"))
    printf("Record again the spectrum of the free protein, and then inspect %s to space your additions properly\n", dispCommand("report"))
    disp("")
elseif titrationPoint <= 4
    % user first needs to do at least four additions
    disp("")
    printf("Easy.., you have only done %d addition of ligand...\n", tp)
    disp("Your protein is not saturated yet with the ligand.")
    printf("First add some more ligand by typing %s at the command prompt.\n", dispCommand("titrate"))
    disp("")
elseif pb < 0.7
    disp("")
    disp("Try adding more ligand to your protein.")
    disp("It looks like you're not done yet.")
    disp("")
    printf("Check how far you are with %s and more ligand with %s\n", dispCommand("report"), dispCommand("titrate"))
    disp("")
elseif pb < 0.8 && timeSpent < 5400 && easyMode == 1 && pConc > 0.25
    % check whether already spent more than 1.5 hrs = 90*60 = 5400 sec
    disp("")
    disp("Try adding more ligand to your protein.")
    disp("It looks like you're not done yet. Try to reach at least 80 percent bound protein.")
    disp("You still have time.")
    disp("")
    printf("Check how far you are with %s and more ligand with %s\n", dispCommand("report"), dispCommand("titrate"))
    disp("")
elseif pb < 0.8 && timeSpent < 2700 && easyMode > 1 && pConc > 0.25
    % check whether already spent more than 45min = 45*60 = 2700 sec
    disp("")
    disp("Try adding more ligand to your protein.")
    disp("It looks like you're not done yet. Try to reach at least 80 percent bound protein.")
    disp("You still have time.")
    disp("")
    printf("Check how far you are with %s and more ligand with %s\n", dispCommand("report"), dispCommand("titrate"))
    disp("")
else % enough titrationPoints and over 70%
    if pb < 0.8 && beNice == 1
        % this should only pop up between 0.7 and 0.8 so at borderline case
        % but protein is already dilute or time is already running out so offer option to continue with CSP analysis
        disp("")
        printf("%s", CYN)
        disp("Hmmm, it looks like you could still add more ligand.")
        disp("The CSP analysis works best of your protein is more than 80% bound")
        disp("If you already spent really a lot of time to get to this point, you have the option to continue with the analysis.")
        printf("%s", WHT)
        disp("")
        % get time spent since getting here
        timeSpent = toc(totalTime);
        if affinityValue*1e3 < proteinConc && molEq < 1.5
            % check whether plateau has been reached in particular for high affinity binders
            disp("")
            disp("Even though the affinity is rather high, and your protein is nearly completely bound to ligand,")
            disp("it is better to record an additional point to measure the binding plateau.")
            printf("Type %s to see how far you are in the titration.\n", dispCommand("report"))
            printf("Type %s to add more ligand, increase to at least 1.5 equivalents of ligand.\n", dispCommand("titrate"))
        end
        disp("")
        printf("Continue anyway, or do first another %s.\n", dispCommand("titrate"))
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
    if continueCalcQuestion == "y"
        clc
        disp("")
        printf("%s", YEL)
        disp("*----------------------------------------------------------*")
        if easyMode == 3
            disp("***         STEP 5 of 5: ANALYSIS                        ***")
        else
            disp("***         STEP 6 of 6: ANALYSIS                        ***")
        end
        disp("*----------------------------------------------------------*")
        printf("%s", WHT)
        % give intro how to use it
        disp("")
        disp("Wait a sec, saving a backup of your work before continuing ...")
        % remove audioplayer objects before saving 
        clear player
        save "state.out"
        disp("")
        disp("Backup saved!")
        disp("")
        disp("Great, now that you have finished the titration it is time to analyse the data.")
        disp("")
        disp("You will do the chemical shift perturbation analysis")
        disp("determine the binding interface and the binding affinity.")
        disp("")
        disp("Each of these steps is a question that will be scored.")
        disp("")
        showBreak
        disp("")
        disp("OK, the first step is the chemical shift perturbation analysis,")
        disp("which is simply determining for each peak the change in chemical shift.")
        disp("")
        disp("To do this, first identify which peak shifts where, making use of this hint:")
        printf("\t - typically (in this simulated experiment) there are %d peaks that don't move,\n", numSmall)
        printf("\t   %d that move a little and %d that move a big distance.\n", numMed, numBig)
        disp("")
        disp("Depending on the exchange regime it may be easy or hard to")
        disp("see where the peaks move to.")
        if max(abs(dwHv./(2*koff))) > 2 || max(abs(dwNv./(2*koff))) > 2
            printf("%s", CYN)
            disp("Even in slow/intermediate exchange, there are usually small shifts visible")
            disp("at the start and end of the titration that you can use")
            disp("to track the direction that the peaks move.")
            disp("You may have to change the contouring of the spectra to see closer to the noise level")
            printf("%s", WHT)
        end
        disp("")
        showBreak
        disp("")
        disp("Look carefully at each peak to identify where they go.")
        disp("Make sure you have the whole spectrum with all peaks visible.")
        disp("")
        disp("It can help to make spectrum window larger.")
        printf("If you cannot see the peak labels well, issue %s at the command prompt.\n", dispCommand("plotAll"))
        disp("")
        if titrationPoint > maxSpectra % have set this to be more than 15
            printf("%s", CYN)
            disp("Since you have many overlaid spectra , first simplify this using")
            printf("the %s command.\n", dispCommand("reduceOverlay"))
            printf("%s", WHT)
        end
        if peakDissappearCheck < 0.2*sino/120*startFloor/0.05 && beNice == 1
            % checked that 0.2 is good setting default plot, w/ 120 starting sino
            % show contour tip if sino of peak too low
            disp("")
            printf("%s", CYN)
            disp("To do this analysis you need see the start and end position for each residue.")
            disp("If you cannot see all peaks, adjust the contour levels to start closer to the noise level")
            printf("Type %s at the command prompt to adjust the contour settings,\n", dispCommand("edlev"))
            disp("and adjust the last number to 0.04 or lower")
            printf("%s", WHT)
            disp("")
        end
        if length(overlap) > 0 && ( any(overlap == minS2peak) || any(overlap == maxS2peak) )
            disp("")
            printf("%s", CYN)
            disp("Hmmm, it looks like you have a very complicated case, with some overlapping peaks")
            disp("Maybe check with your instructor when answering the question.")
            disp("Be sure to enlarge the spectrum window and zoom in on the region with all peaks.")
            printf("%s", WHT)
            disp("")
        end
        disp("Other commands that are useful:")
        printf("\t - %szoomPeak%s     (to zoom in on a peak)\n", RED, WHT)
        printf("\t - %szoomFull%s     (to go back to full view)\n", RED, WHT)
        printf("\t - %sedlev%s        (to change the contouring)\n", RED, WHT)
        printf("\t - %splotAll%s      (to replot all spectra and put labels on top\n", RED, WHT)
        disp("")
        disp("When you have setup the spectrum properly and are ready for it,")
        printf("type %s to do the chemical shift perturbation analysis", dispQuestion(cspq))
        disp("")
    end % intro
end % check enough titrationPoints
