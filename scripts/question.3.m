% question.3.m

% question file for easyMode = 3

function question(number)

global score S2Values koff numPeaks dwNv dwHv questionPoints questionAsked yourName affinityRange
global acronymProtein acronymLigand ligandDescriptor easyMode cq numQuestions instructorMail sendEmail ligandClass
global molEq beNice aa_string cspq titrationPoint pb colorNamesLong wHvppm wNvppm dwHvppm dwNvppm 
global cspTime numBig numSmall kdq affinityValue proteinConc plotPoints colorPlot asHppm asNppm
global plotSpectra cntLvls lConcv molEqv beNice CSP_o CSP_f CSP getkdTime pbVectorActual kdq


    disp("")
    if number == 1 && questionAsked(number) == 0
        disp("")
        disp("You will now get your first multiple-choice question.")
        disp("To answer just type any of the options A, B, C, etc. when prompted.")
        disp("Just a, b, c etc. also works.")
        disp("")
        disp("Please note that you can only enter your answer when prompted.")
        disp("Anything that you type when you see <> is ignored.")
        disp("")
        printf("If your answer is correct, you get the full %d points.\n", questionPoints)
        printf("If it is wrong, you can answer once more, for %d points.\n", round(0.25*questionPoints) )
        disp("")
        junk=input("<>","s");
        disp("");
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        printf("+++               QUESTION 1 (of %d)                      +++\n",numQuestions)
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        disp("")
        if ligandClass > 0
            disp("You're investigating an interaction between two proteins.")
        else
            disp("You're investigating the interaction between a protein and a smaller molecule.")
        end
        disp("")
        disp("What labeling strategy is best to use? Also consider costs.")
        disp("")
        if ligandClass ==  0
            disp("    A. The ligand should be 15N-labeled, the protein unlabeled.")
            disp("    B. The ligand should be unlabeled, the protein 15N-labeled.")
            disp("    C. The ligand should be unlabeled, the protein 13C-labeled.")
            disp("    D. The ligand should be 13C-labeled, the protein 15N-labeled.")
        else
            disp("    A. Both proteins should be 15N-labeled.")
            disp("    B. One of the protein should be 15N-labeled.")
            disp("    C. Both proteins should be 13C-labeled.")
            disp("    D. One of the proteins should be 13C-labeled.")
        end
        disp("")
        answer1 = input("Enter your answer: ","s");
        answer1 = checkAnswer(answer1);
        score   = calcScore(answer1, score, "B", questionPoints);
        questionAsked(1)=1;
        junk=input("<>","s");
        disp("");
        disp("EXPLANATION:")
        if ligandClass == 0
            disp("As we want to follow the peaks of the protein, it should be isotope labeled.")
            disp("Cheapest, most practical option is to leave the ligand unlabeled.")
        else
            disp("To map the binding site of one protein on the other, only one should be labeled")
            disp("otherwise you will get a complicated mixture of the NMR signals of both proteins.")
        end
        disp("The protein is best labeled with 15N, as the backbone amide chemical shifts")
        disp("are very sensitive to binding events, more so than 13C chemical shifts.")
        disp("So B is the right answer.");
        disp("")
        disp("NEXT:")
        disp("")
        disp("Now you need to make your protein NMR sample and ligand stock solution.")
    elseif number == 2 && questionAsked(number) == 0
        [val, minS2peak] = min(S2Values);
        [val, maxS2peak] = max(S2Values);
        peakLabel1 = strcat(aa_string(minS2peak),num2str(minS2peak));
        peakLabel2 = strcat(aa_string(maxS2peak),num2str(maxS2peak));
        disp("")
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        printf("+++               QUESTION 2 (of %d)                      +++\n",numQuestions)
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        disp("")
        disp("Peak intensity is related to molecular size.")
        disp("Small molecules have sharp, intense lines. Big molecules have broad, weak lines.")
        disp("")
        printf("The peak of residue %s has a higher intensity than that of residue %s.\n", peakLabel1, peakLabel2)
        disp("How can this be explained?")
        printf("    A. The peak of residue %s experiences less internal dynamics,\n", peakLabel1)
        disp("       which means that effectively it is like a smaller molecule")
        disp("")
        printf("    B. The peak of residue %s has a higher intensity, because it is the signal of more protons.\n", peakLabel1)
        disp("")
        printf("    C. The peak of residue %s experiences more internal dynamics, \n", peakLabel1)
        disp("       which means that effectively it is like a smaller molecule.")
        disp("")
        printf("    D. The peak of residue %s has a higher intensity, because it just happens to be so due to the noise.\n", peakLabel1)
        disp("")
        answer2 = input("Enter your answer: ","s");
        answer2 = checkAnswer(answer2);
        score   = calcScore(answer2, score, "C", questionPoints);
        junk=input("<>","s");
        disp("")
        disp("EXPLANATION:")
        disp("C is right here. The differences in peak intensities are caused by differences in local dynamics.")
        disp("For instance termini will be more floppy, more dynamic than the folded core of the protein.")
        disp("Floppy bits will behave like small molecules and have sharper, more intense lines.")
        questionAsked(2) = 1;
         % now prompt student to start with titration
        disp("")
        junk=input("<>","s");
        disp("");
        disp("Beautiful, you now have a fingerprint 15N-HSQC spectrum of your protein.")
        disp("Compare your spectrum with that of your (virtual) neighbour.")
        disp("")
        junk=input("<>","s");
        disp("");
        disp("Now let's finally start with the titration and see whether the peaks move ...")
        disp("Type \"titrate\" at the command prompt.")
        disp("")
    elseif number == 3 && questionAsked(number) == 0
        disp("")
        disp("Time for an intermezzo question!")
        disp("You have added now more than 1 molar equivalent of ligand to the protein.")
        disp("Time to consider how much you should add to have all binding sites")
        disp("on the protein fully occupied with ligand.")
        disp("")
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        printf("+++               QUESTION 3 (of %d)                      +++\n",numQuestions)
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        disp("")
        disp("You are about to exceed 1 molar equivalent of ligand added.")
        disp("Time to consider how much you should add to have that all binding sites on the protein")
        disp("are fully occupied with ligand.")
        disp("")
        disp("What ligand concentration is needed to (completely) saturate the protein?")
        disp("    A. Depends on the affinity and the protein concentration.")
        disp("    B. Depends on the affinity")
        disp("    C. Depends on the protein concentration.")
        disp("    D. Depends on the association-rate.")
        disp("")
        answer3 = input("Enter your answer: ","s");
        answer3 = checkAnswer(answer3);
        score   = calcScore(answer3, score, "A", questionPoints);
        junk=input("<>","s");
        disp("");
        disp("EXPLANATION:")
        disp("Obviously the ligand concentration needed to saturate the protein depends on the binding affinity")
        disp("It also depends on your protein concentration.")
        disp("")
        disp("Imagine you have an immensely concentrated protein solution.")
        disp("Then you need to add more ligand to bind all proteins compared to when you have very little protein.")
        disp("")
        disp("Using the power of math, you can derive that you need")
        disp("approximately 9*KD + the protein concentration to get 90% of all binding-sites occupied.")
        disp("So A is the right answer.");
        disp("")
        junk=input("<>","s");
        disp("")
        %printf("In your system the KD is in the %s range.\n", affinityRange)
        disp("Continue the titration until you see no more significant changes in the spectrum")
        disp("You can also take a peek at the %bound protein using \"report\"...")
        disp("")
        disp("When you have all your spectra, issue \"calcCSP\" to analyse the changes in the spectra.")
        disp("")
        junk=input("<>","s");
        questionAsked(3)=1;
    elseif number == 4 && questionAsked(number) == 0
        disp("")
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        printf("+++               QUESTION 4 (of %d)                      +++\n",numQuestions)
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        disp("")
        questionCSP
    elseif number == 5 && questionAsked(number) == 0
        disp("")
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        printf("+++               QUESTION 5 (of %d)                      +++\n",numQuestions)
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        disp("")
        questionInterface
    elseif number == 6 && questionAsked(number) == 0
        disp("")
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        printf("+++               QUESTION 6 (of %d)                      +++\n",numQuestions)
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        disp("")
        getKD
    elseif number == 7 && questionAsked(number) == 0
        % summary of the practical
        disp("")
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        printf("+++               QUESTION 7 (of %d)                      +++\n",numQuestions)
        disp("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        disp("")
        printf("How would you proceed to model the interaction between %s and %s?\n", acronymProtein, acronymLigand)
        disp("(Assuming you have structures for both...)")
        disp("    A. Use the residues with the largest CSPs to drive a docking calculation")
        disp("    B. Check whether the residues with the largest CSPs cluster on the surface")
        disp("    C. Repeat the titration experiment but then reversed to get CSPs on the ligand")
        disp("    D. Repeat the titration experiment to reproduce the results.")
        disp("")
        answer7 = input("Enter your answer: ","s");
        answer7 = checkAnswer(answer7);
        tru7 = "B";
        score    = calcScore(answer7, score, tru7, questionPoints);
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
        questionAsked(7)=1;
        junk=input("<>","s");
        %clc
        questionAsked(7) = 1;
        checkFinished
    elseif questionAsked(number) == 1
        disp("")
        disp("Ha! We don't play that way.")
        disp("You already answered this question ...")
        disp("")
    else
        printf("Uh, I don't know question %d.\n", number)
    end

endfunction
