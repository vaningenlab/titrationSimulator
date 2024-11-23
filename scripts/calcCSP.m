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
    if continueCalcQuestion == "y"
        clc
        disp("")
        disp("*----------------------------------------------------------*")
        if easyMode == 3
            disp("***         STEP 5 of 5: ANALYSIS                        ***")
        else
            disp("***         STEP 6 of 6: ANALYSIS                        ***")
        end
        disp("*----------------------------------------------------------*")
        % give intro how to use it
        disp("")
        disp("Wait a sec, saving a backup of your work before continuing ...")
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
        junk=input("<>","s");
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
        disp("If you cannot see the peak labels well, issue \"plotAll\" at the command prompt.")
        disp("")
        if titrationPoint > maxSpectra % have set this to be more than 15
            disp("Since you have many overlaid spectra , first simplify this using")
            disp("the \"reduceOverlay\" command.")
        end
        if peakDissappearCheck < 0.2*sino/120*startFloor/0.05 && beNice == 1
            % checked that 0.2 is good setting default plot, w/ 120 starting sino
            % show contour tip if sino of peak too low
            disp("")
            disp("To do this analysis you need see the start and end position for each residue.")
            disp("If you cannot see all peaks, adjust the contour levels to start closer to the noise level")
            disp("Type \"edlev\" at the command prompt to adjust the contour settings,")
            disp("and adjust the last number to 0.04 or lower")
            disp("")
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
        disp("\t - edlev        (to change the contouring)")
        disp("\t - plotAll      (to replot all spectra and put labels on top")
        disp("")
        disp("When you have setup the spectrum properly and are ready for it,")
        printf("type question(%d) to do the chemical shift perturbation analysis", cspq)
        disp("")
    end % intro
end % check enough titrationPoints
