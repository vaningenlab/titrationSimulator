% question.1.m

% question file for easyMode = 1

function question(number)

global score S2Values koff numPeaks dwNv dwHv questionPoints questionAsked yourName affinityRange aa_string
global acronymProtein acronymLigand ligandDescriptor easyMode cq instructorMail atH atN numQuestions
global dwNvppm dwHvppm numPeaks laN_Av laN_Bv titrationPoint peakIntProfile

    disp("")
    if number == 1 && questionAsked(number) == 0
        disp("")
        disp("QUESTION 1.")
        disp("What labeling strategy is best to use? Also consider costs.")
        disp("    A. The ligand should be 15N-labeled, the protein unlabeled.")
        disp("    B. The ligand should be unlabeled, the protein 15N-labeled.")
        disp("    C. The ligand should be unlabeled, the protein 13C-labeled.")
        disp("    D. The ligand should be 13C-labeled, the protein 15N-labeled.")
        disp("")
        answer1 = input("Enter your answer: ","s");
        answer1 = checkAnswer(answer1);
        score   = calcScore(answer1, score, "B", questionPoints);
        questionAsked(1)=1;
        junk=input("<>","s");
        disp("");
        disp("EXPLANATION:")
        disp("As we want to follow the peaks of the protein, it should be isotope labeled.")
        disp("Cheapest, most practical option is to leave the ligand unlabeled.")
        disp("The protein is best labeled with 15N, as the backbone amide chemical shifts")
        disp("are very sensitive to binding events, more so than 13C chemical shifts.")
        disp("Labeling with 15N is also signifcantly cheaper than labeling with 13C.")
        disp("So B is the right answer.");
        disp("")
    elseif number == 2 && questionAsked(number) == 0
        disp("QUESTION 2.")
        disp("Examine the pulse calibration plot. When do you see no signal?")
        disp("    A. If you don't apply a pulse")
        disp("    B. If the magnetization is along the z-axis")
        disp("    C. If you give a 180-degree pulse")
        disp("    D. All of the above.")
        disp("")
        answer2 = input("Enter your answer: ","s");
        answer2 = checkAnswer(answer2);
        score   = calcScore(answer2, score, "D", questionPoints);
        junk=input("<>","s");
        disp("")
        disp("EXPLANATION:")
        disp("In equilibrium the magnetization is along the magnetic field (the z-axis) and not detectable.")
        disp("There will only be signal if the magnetization has been rotated to have a component in the xy-plane.")
        disp("Thus, there will be no signal at 180, 360, 540 degrees, etc (magnetization along + or -z)")
        disp("")
        junk=input("<>","s");
        disp("");
        disp("NEXT:")
        disp("As it is easier to check for zero of a sinoid signal than a maximum,")
        disp("your task is to identify the pulse length value at which you get a zero-crossing")
        disp("corresponding to a 180 or 360 degree rotation of the magnetization.")
        disp("")
        disp("Run this experiment again with adjusted range of pulse lengths to zoom in on the zero-crossing.")
        disp("Type \"zg\" to run it again")
        disp("")
        questionAsked(2)=1;
    elseif number == 3 && questionAsked(number) == 0
        disp("")
        disp("QUESTION 3.")
        disp("The HSQC experiment is a two dimensional experiment")
        disp("that shows a signal for all NH groups in a protein.")
        disp("")
        disp("Suppose you have a NH2 group in the protein:")
        disp("two protons connected to the same nitrogen.")
        disp("")
        disp("Which statement is true?")
        disp("    A. There will be two peaks on a horizontal line")
        disp("    B. There will be one peak in the HSQC spectrum: at the average H and N chemical shift")
        disp("    C. There will be one peak in the HSQC spectrum: only one of two H's will give a signal")
        disp("    D. There will be no peak in the HSQC")
        disp("")
        answer3 = input("Enter your answer: ","s");
        answer3 = checkAnswer(answer3);
        score   = calcScore(answer3, score, "A", questionPoints);
        questionAsked(3)=1;
        junk=input("<>","s");
        disp("")
        disp("EXPLANATION:")
        disp("A. is the correct answer. NH2 groups are present in asparagine and glutamine side chains.")
        disp("The two protons have different chemical shifts.")
        disp("Both will give a peak at the same 15N chemical shift")
        disp("These sidechains are thus easily recognized as two signals on a horizontal line.");
        disp("In the simulated spectra here only the backbone NHs will show up as signals.")
        disp("")
        junk=input("<>","s");
        clc
        disp("")
        disp("***      4. Protein HSQC      ***")
        disp("")
        disp("")
        disp("Now enter the acquisition times:")
        disp("")
    elseif number == 4 && questionAsked(number) == 0
        disp("QUESTION 4.")
        disp("Which statement is true?")
        disp("    A. Increasing the length of the acquisition time, decreases the resolution.")
        disp("       Increasing the number of scans by factor of 2, increases the signal-to-noise by 2.")
        disp("")
        disp("    B. Increasing the length of the acquisition time, decreases the resolution.")
        disp("       Increasing the number of scans by factor of 2, increases the signal-to-noise by sqrt(2).")
        disp("")
        disp("    C. Increasing the length of the acquisition time, increases the resolution.")
        disp("       Increasing the number of scans by factor of 2, increases the signal-to-noise by 2.")
        disp("")
        disp("    D. Increasing the length of the acquisition time, increases the resolution.")
        disp("       Increasing the number of scans by factor of 2, increases the signal-to-noise by sqrt(2).")
        disp("")
        answer4 = input("Enter your answer: ","s");
        answer4 = checkAnswer(answer4);
        score   = calcScore(answer4, score, "D", questionPoints);
        junk=input("<>","s");
        disp("")
        disp("EXPLANATION:")
        disp("D is correct. The length of the acquisition time determines the magnitude of")
        disp("the frequency difference that can still be identified in the spectrum, thus the resolution.")
        disp("")
        disp("The sensitivity (signal-to-noise) increases as the square-root of the number of scans.")
        disp("Both signal and noise accumalate but due to the random nature of the noise, it adds up")
        disp("not linearly, but as the square-root.")
        disp("")
        junk=input("<>","s");
        disp("")
        disp("Now re-record the HSQC making sure it has a good S/N and good resolution.")
        disp("Then I have another question for you before you can really start with the titration.")
        disp("So first use \"eda\" to set-up your HSQC, then \"zg\" to run it, and \"xfb\" to process it.")
        disp("")
        questionAsked(4) = 1;
    elseif number == 5 && questionAsked(number) == 0
        [val, minS2peak] = min(S2Values);
        [val, maxS2peak] = max(S2Values);
        disp("QUESTION 5.")
        disp("Peak intensity is related to molecular size.")
        disp("Small molecules have sharp, intense lines. Big molecules have broad, weak lines.")
        disp("")
        printf("Peak %d has a higher intensity than peak %d.\n", minS2peak, maxS2peak)
        disp("How can this be explained?")
        printf("    A. Peak %d experiences less internal dynamics,\n", minS2peak)
        disp("       which means that effectively it is like a smaller molecule")
        disp("")
        printf("    B. Peak %d has a higher intensity, because it is the signal of more protons.\n", minS2peak)
        disp("")
        printf("    C. Peak %d experiences more internal dynamics, \n", minS2peak)
        disp("       which means that effectively it is like a smaller molecule.")
        disp("")
        printf("    D. Peak %d has a higher intensity, because it just happens to be so due to the noise.\n", minS2peak)
        disp("")
        answer5 = input("Enter your answer: ","s");
        answer5 = checkAnswer(answer5);
        score   = calcScore(answer5, score, "C", questionPoints);
        junk=input("<>","s");
        disp("")
        disp("EXPLANATION:")
        disp("C is right here. The differences in peak intensities are caused by differences in local dynamics.")
        disp("For instance termini will be more floppy, more dynamic than the folded core of the protein.")
        disp("Floppy bits will behave like small molecules and have sharper, more intense lines.")
        disp("")
        disp("You can now close the Figure 3 with the 3D spectrum.")
        disp("")
        questionAsked(5) = 1;
        % now prompt student to start with titration
        disp("")
        junk=input("<>","s");
        disp("");
        % double check that resolution is sufficient
        if atH < 0.06 || atN < 0.03
            disp("")
            disp("I just checked your acquisition parameters")
            disp("and it seems your acquisition times are still bit short.")
            disp("This will make your analysis later on more difficult")
            disp("")
            junk=input("<>","s");
            disp("")
            disp("Use \"eda\" to set 1H acquisition time to at least 60ms and ")
            disp("the 15N acquisition time to at least 30ms.")
            disp("Then record the spectrum againg with \"zg\" and process with \"xfb\".")
            disp("")
            disp("Once that is done you have your spectrum of the free protein")
            disp("and you can start the titration by typing \"titrate\".")
            disp("Good luck!")
            disp("")
        else
            disp("")
            disp("Beautiful, you now have a fingerprint 15N-HSQC spectrum of your protein in the free state.")
            disp("Compare your spectrum with that of your (virtual) neighbour.")
            disp("")
            junk=input("<>","s");
            disp("");
            disp("Now let's finally start with the titration and see whether the peaks move ...")
            disp("Type \"titrate\" at the command prompt.")
            disp("")
        end
    elseif number == 6 && questionAsked(number) == 0
        disp("You are about to exceed 1 molar equivalent of ligand added.")
        disp("Time to consider how much you should add to have that all binding sites on the protein")
        disp("are fully occupied with ligand.")
        disp("")
        disp("QUESTION 6.")
        disp("What ligand concentration is needed to (completely) saturate the protein?")
        disp("    A. Depends on the affinity and the protein concentration.")
        disp("    B. Depends on the affinity")
        disp("    C. Depends on the protein concentration.")
        disp("    D. Depends on the association-rate.")
        disp("")
        answer6 = input("Enter your answer: ","s");
        answer6 = checkAnswer(answer6);
        score   = calcScore(answer6, score, "A", questionPoints);
        junk=input("<>","s");
        disp("");
        disp("EXPLANATION:")
        disp("Obviously the ligand concentration needed to saturate the protein depends on the affinity.")
        disp("It also depends on your protein concentration.") 
        disp("")
        disp("Imagine you have an immensely concentrated protein solution.")
        disp("Then you need to add more ligand to bind all proteins compared to when you have very little protein.")
        disp("")
        disp("Using the power of math, you can derive that approximately 9*KD + protein concentration is needed")
        disp("to get 90% of all binding-sites occupied.")
        disp("So A is the right answer.");
        disp("")
        junk=input("<>","s");
        disp("")
        printf("In your system the KD is in the %s range.\n", affinityRange)
        disp("Continue the titration until you see no more significant changes in the spectrum.")
        disp("You can also take a peek at the %bound protein using \"report\"...")
        disp("")
        disp("When you have all your spectra, issue \"calcCSP\" to analyse the changes in the spectra.")
        disp("")
        junk=input("<>","s");
        questionAsked(6)=1;
    elseif number == 7 && questionAsked(number) == 0
        disp("")
        disp("QUESTION 7.")
        disp("Consider the following factors:")
        disp("    A. sample dilution")
        disp("    B. interconversion between free and bound protein")
        disp("    C. increase in mass upon complex formation")
        disp("    D. rigidification upon binding")
        disp("")
        disp("Which of the these will not necessarily result in lower intensities?")
        disp("")
        answer7 = input("Enter your answer: ","s");
        answer7 = checkAnswer(answer7);
        score   = calcScore(answer7, score, "B", questionPoints);
        junk=input("<>","s");
        disp("");
        disp("EXPLANATION:")
        disp("In this setup,each addition of ligand increases the volume and thus dilutes the protein.")
        disp("As a result the peak intensity will decrease during the titration.")
        disp("You can minimize this by working at low protein and maximum ligand stock concentration.")
        disp("Or you could make a series of samples at constant protein but increasing ligand concentration.") 
        disp("But here each step will always reduce peak intensities.")
        disp("")
        junk=input("<>","s");
        disp("")
        disp("When a ligand binds, the protein will increase in size effectively.")
        disp("This effect is of course much stronger if the ligand is another protein than a small compound.")
        disp("Increase in molecular masss will always result in broader lines and thus lower intensity.")
        disp("")
        junk=input("<>","s");
        disp("")
        disp("Binding could cause a loop to become less flexible, this would then also lead to reduced")
        disp("peak intensities.")
        disp("")
        junk=input("<>","s");
        disp("")
        disp("The conformational exchange between free and bound protein can indeed cause broadening of the lines,")
        disp("and thus reduction in peak intensity.")
        disp("But this will only happen if that particular residue is in different environments in")
        disp("free and bound states: there has to be a chemical shift difference.")
        disp("Also the effect will depend on the exchange regime.")
        disp("")
        disp("So B is the right answer.");
        disp("")
        junk=input("<>","s");
        disp("")
        disp("Now continue the titration until you see no more significant changes in the spectrum.")
        disp("You can also take a peek at the %bound protein using \"report\"...")
        disp("")
        disp("When you have all your spectra, issue \"calcCSP\" to analyse the changes in the spectra.")
        disp("")
        junk=input("<>","s");
        questionAsked(7)=1;
    % calcCSP has question 8 and 9
    % getKD has question 10
    elseif number == 8 && questionAsked(number) == 0
        disp("")
        disp("Seems you have not completed the CSP analysis.")
        disp("Type \"calcCSP\" at the command prompt to start it.")
        disp("")
    elseif number == 9 && questionAsked(number) == 0
        disp("")
        disp("Seems you have not completed the CSP analysis.")
        disp("Type \"calcCSP\" at the command prompt to start it.")
        disp("")
    elseif number == 10 && questionAsked(number) == 0
        disp("")
        disp("Seems you did not determine the KD.")
        disp("Type \"getKD\" at the command prompt to start the analysis.")
        disp("")
    elseif number == 11 && questionAsked(number) == 0
        % judge exchange regime
        % does not make sense to do all peaks, since most will be fast exchange
        % so take smallest, median, and 2 largest CSP peaks = 4 peaks
        truCSP = sqrt((dwNvppm./(5)).^2+(dwHvppm).^2);
        [ sss, iii ] = sort(truCSP);
        smallCSP = iii(1:1);
        medianCSP = iii(round(numPeaks/2));
        largeCSP = iii(numPeaks-1:numPeaks);
        questionPeaks = sort([smallCSP, medianCSP, largeCSP]);
        disp("QUESTION 11.")
        disp("")
        disp("I will now ask you to classify for a few peaks whether it is ")
        disp("fast, intermediate or slow exchange.")
        disp("For every peak, the 1D slices of that peak in all spectra will be shown.")
        disp("")
        junk=input("<>","s");
        oldScore = score;
        % 4 peaks with 2 points each, so 2 bonus points
        score=score+2;
        disp("")
        for qp=1:length(questionPeaks)
            p = questionPeaks(qp);
            peakLabel = strcat(aa_string(p),num2str(p));
            showSlices(p,"b")
            printf("Peak %s:\n", peakLabel)
            disp("    A. does not experience any exchange.")
            disp("    B. is in slow exchange.")
            disp("    C. is in intermediate exchange.")
            disp("    D. is in fast exchange.")
            disp("    E. is inbetween fast and intermediate exchange")
            disp("    F. is inbetween slow and intermediate exchange")
            disp("")
            answer11 = input("Enter your answer: ","s");
            answer11 = checkAnswer6(answer11);
            disp("")
            % calculate true dw/kex ratio's; crossover = kex=dw/2 dw/kex = 2 is intermediate
            aH = abs(dwHv(p))/(2*koff);
            aN = abs(dwNv(p))/(2*koff);
            % also calculate normalized peak intensity profile
            normPeak  = peakIntProfile./peakIntProfile(1);
            tp        = titrationPoint;
            % check for dip in intensity at midpoint compared to end point
            relMidInt = normPeak(round(tp/2))/normPeak(tp);
            %        1   : cross-over point = intermediate
            % 100 - 8    : slow
            %   8 - 2    : slow intermediate
            %   2 - 1    : intermediate
            %   1 - 0.25 : fast intermediate    dip in intensities around midpoint
            %   0.25 - ..: fast                 no dip in intensities around midpoint
            if abs(dwHv(p)) < 6 && abs(dwNv(p)) < 6
                % no exchange
                if answer11 == "A"
                    disp("Yes, nothing moving here, so no exchange!")
                    score = score +2;
                else
                    disp("If there is no chemical shift difference,")
                    disp("then there is not really any exchange experienced for this peak.")
                end
            elseif aH > 8 || aN > 8
                % slow exchange, should not occur
                if answer11 == "B"
                    disp("Yes, the peak dissappears and then reappears, so slow exchange.")
                    score = score +2;
                else
                    disp("Ah, no this peak is in slow exchange as it dissappears")
                    disp("in the first part and then reappears at last part of the titration.")
                end
                disp("Inspect the information below, specifically ")
                disp("the ratio of dw (=chemical shift difference in rad s-1) to kex (the exchange rate).")
                disp("As you can see dw is much larger than kex.")
                peakInfo(p)
            elseif aH > 2 || aN > 2
                % slow-intermediate
                if answer11 == "B"
                    disp("Yes, the peak dissappears and then reappears, so slow exchange.")
                    disp("If you look more carefully you can see that it also broadens a lot")
                    disp("So you can also call this slow-to-intermediate exchange")
                    score = score +2;
                elseif answer11 == "F"
                    disp("Yes, the peak is in between slow and intermediate exchange.")
                    score = score +2;
                else
                    disp("Ah, no this peak is in slow-intermediate exchange as it dissappears")
                    disp("in the first few points very quickly and then reappears at last part of the titration.")
                end
                disp("Inspect the information below, specifically ")
                disp("the ratio of dw (=chemical shift difference in rad s-1) to kex (the exchange rate).")
                disp("As you can see dw is larger than kex, but not many times larger.")
                peakInfo(p)
            elseif aH > 1 || aN > 1 
                % intermediate
                if answer11 == "C"
                    disp("Yes, the peak intensity decreases a lot around the midpoint,")
                    disp("but then increases again towards the end of the titration.")
                    disp("This is intermediate exchange.")
                    score = score +2;
                else
                    disp("Well, the peak intensity decreases a lot around the midpoint,")
                    disp("but then increases again towards the end of the titration.")
                    disp("This is intermediate exchange.")
                end
                disp("Inspect the information below, specifically ")
                disp("the ratio of dw (=chemical shift difference in rad s-1) to kex (the exchange rate).")
                disp("As you can see dw is comparable to kex.")
                peakInfo(p)
            elseif aH > 0.25 || aN > 0.25
                % fast-intermediate
                if answer11 == "C"
                    disp("Yes, the peak intensity decreases somewhat around the midpoint,")
                    disp("but the effect is not dramatic and also looks like the peak")
                    disp("is just gradually shifting.")
                    disp("So it is best to call this fast-to-intermediate exchange.")
                    disp("Still 2 points extra.")
                    score = score +2;
                elseif answer11 == "E"
                    disp("Perfect, the peak intensity decreases somewhat around the midpoint,")
                    disp("but the effect is not dramatic and also looks like the peak")
                    disp("is just gradually shifting.")
                    disp("So it is indeed best to call this fast-to-intermediate exchange.")
                    score = score +2;
                else
                    disp("Well, the peak intensity decreases somewhat around the midpoint,")
                    disp("but the effect is not dramatic and also looks like the peak")
                    disp("is just gradually shifting.")
                    disp("So it is indeed best to call this fast-to-intermediate exchange.")
                end
                disp("Inspect the information below, specifically ")
                disp("the ratio of dw (=chemical shift difference in rad s-1) to kex (the exchange rate).")
                disp("As you can see dw is bit smaller than kex.")
                peakInfo(p)
            elseif relMidInt < 0.9
                % fast-intermediate
                if answer11 == "C"
                    disp("Yes, the peak intensity decreases somewhat around the midpoint,")
                    disp("but the effect is not dramatic and also looks like the peak")
                    disp("is just gradually shifting.")
                    disp("So it is best to call this fast-to-intermediate exchange.")
                    disp("Still 2 points extra.")
                    score = score +2;
                elseif answer11 == "E"
                    disp("Perfect, the peak intensity decreases somewhat around the midpoint,")
                    disp("but the effect is not dramatic and also looks like the peak")
                    disp("is just gradually shifting.")
                    disp("So it is indeed best to call this fast-to-intermediate exchange.")
                    score = score +2;
                else
                    disp("Well, the peak intensity decreases somewhat around the midpoint,")
                    disp("but the effect is not dramatic and also looks like the peak")
                    disp("is just gradually shifting.")
                    disp("So it is indeed best to call this fast-to-intermediate exchange.")
                end
                disp("Inspect the information below, specifically ")
                disp("the ratio of dw (=chemical shift difference in rad s-1) to kex (the exchange rate).")
                disp("As you can see dw is bit smaller than kex.")
                peakInfo(p)
            else
                % fast exchange, aH || aN less than 0.25 and no dip in center
                if answer11 == "D"
                    disp("Yes, the peak just gradually shifts in position with just a gradual drop")
                    disp("in intensity due to dilution. This is fast exchange.")
                    score = score +2;
                else
                    disp("Well, the peak just gradually shifts in position. The intensity decreases gradually due to dilution.")
                    if laN_Av(p)/laN_Bv(p) < 0.8
                        disp("In your case the increase of size for the complex is significant which cause further reduction in peak intensities.")
                    end
                    disp("This is fast exchange.")
                end
                disp("Inspect the information below, specifically ")
                disp("the ratio of dw (=chemical shift difference in rad s-1) to kex (the exchange rate).")
                disp("As you can see dw is much smaller than kex.")
                peakInfo(p)
            end % answer options
            disp("")
            junk=input("<>","s");
            clc
        end % peaks
        % summary on score, max is 10 points
        disp("")
        pointScored = score - oldScore;
        if pointScored > 7
                printf("Good job! You got %d points!\n", pointScored)
        elseif pointScored > 5
                printf("Alright, you got %d points extra\n", pointScored)
        else
            printf("That was hard right? You still got %d points though.\n", pointScored)
        end
        disp("")
        disp("Time for the final question: type \"question(12)\".")
        disp("")
        questionAsked(11) = 1;
    elseif number == 12 && questionAsked(number) == 0
        % summary of the practical
        disp("")
        disp("QUESTION 12.")
        printf("How would you proceed to model the interaction between %s and %s?\n", acronymProtein, acronymLigand)
        disp("(Assuming you have structures for both...)")
        disp("    A. Use the residues with the largest CSPs to drive a docking calculation")
        disp("    B. Check whether the residues with the largest CSPs cluster on the surface")
        disp("    C. Repeat the titration experiment but then reversed to get CSPs on the ligand")
        disp("    D. Repeat the titration experiment to reproduce the results.")
        disp("")
        answer12 = input("Enter your answer: ","s");
        answer12 = checkAnswer(answer12);
        tru12 = "B";
        score    = calcScore(answer12, score, tru12, questionPoints);
        disp("")
        disp("EXPLANATION")
        disp("Well, first of all, NMR experiments are typically not repeated.")
        disp("That is not needed because the signal is the average of zillions of molecules.")
        disp("Plus, the signal-to-noise ratio is typically >> 10")
        disp("so that peak positions can be determined extremely accurately.")
        disp("On top of that, most error typically comes from the inaccuracies of the protein concentration,")
        disp("which can easily be 20% off.")
        disp("")
        if strcmp(ligandDescriptor,"compound")
            disp("Since your ligand is a small molecule, option C is not very useful.")
            disp("Likely the whole molecule is part of the interface.")
            disp("Anyways, the right thing to do is first to check whether the binding is specific:")
            disp("in which case all residues with large CSPs should cluster on the outside of the protein.")
        else
            disp("The right thing to do is first to check whether the binding is specific:")
            disp("in which case all residues with large CSPs should cluster on the outside of the protein.")
            disp("Since your ligand is another protein, knowing the binding interface of one of two")
            disp("is not enough to model the complex.")
            disp("You also need to gather data to determine interface residues on the ligand.")
            disp("You could use another titration experiment for that, but also something else like mutagenesis.")
        end
        disp("")
        disp("")
        questionAsked(number)=1;
        junk=input("<>","s");
        clc
        disp("")
        finalScore = 10*score/(10*numQuestions+10);
        printf("+++++++++++++++++++++++++++++++++++++++++++++++\n")
        printf("++                                           ++\n")
        printf("++     This is the end of the practical.     ++\n")
        printf("++                                           ++\n")
        printf("++     You have a final score of %3.1f/10     ++\n", finalScore)
        printf("++     You got %3d points out of %3d         ++\n", score, numQuestions*10+10)
        printf("++                                           ++\n")
        printf("+++++++++++++++++++++++++++++++++++++++++++++++\n")
        disp("")
        if finalScore > 80
            printf("Awesome %s, you did a really great job.\n", yourName)
        elseif finalScore > 60
            printf("Good job %s! You made it to the end and passed it!\n",yourName)
        else
            printf("Alright %s, you made it to the end...\n", yourName)
        end
        disp("You have seen how changes in peak positions can be used to")
        disp("determine the binding interface and binding affinity in")
        disp("protein-ligand interactions.")
        disp("")
        disp("Hope you enjoyed it!")
        disp("")
        disp("One more thing:")
        disp("")
        junk=input("<>","s");
        clc
        disp("")
        disp("Send a figure of your titration spectra, the binding curve and the details of your system")
        disp("to your instructor.")
        disp("")
        disp("First, make sure the whole spectrum is shown (do \"zoomFull\" if necessary).")
        disp("Then make sure all spectra and peak labels are visible (do \"plotAll\" if necessary)")
        disp("")
        disp("Then print your HSQCs and the binding curve with the \"saveFigure\" command.")
        disp("It will put two figures in your working directory.")
        disp("")
        disp("Please do not use the save option from the figure window!")
        disp("")
        disp("Finally, copy the output from the \"systemInfo\" command to a textfile")
        disp("")
        disp("Send the two figures and the \"systemInfo\" output by email to:")
        disp("")
        printf("       %s", instructorMail)
        disp("")
        disp("Once you have sent the figures and output you can close this program by typing \"goodbye\"")
        disp("")
    elseif questionAsked(number) == 1
        disp("")
        disp("Ha! We don't play that way.")
        disp("You already answered this question ...")
        disp("")
    else
        printf("Uh, I don't know question %d.\n", number)
    end

endfunction
