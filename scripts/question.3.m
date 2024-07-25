% question.2.m

% question file for easyMode = 2

function question(number)

global score S2Values koff numPeaks dwNv dwHv questionPoints questionAsked yourName affinityRange
global acronymProtein acronymLigand ligandDescriptor easyMode cq numQuestions instructorMail

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
        disp("So B is the right answer.");
        disp("")
    elseif number == 2 && questionAsked(number) == 0
        [val, minS2peak] = min(S2Values);
        [val, maxS2peak] = max(S2Values);
        disp("QUESTION 2.")
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
            disp("You are about to exceed 1 molar equivalent of ligand added.")
            disp("Time to consider how much you should add to have that all binding sites on the protein")
            disp("are fully occupied with ligand.")
            disp("")
            disp("QUESTION 3.")
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
            disp("Obviously the ligand concentration needed to saturate the protein depends on the affinity")
            disp("It also depends on your protein concentration.") 
            disp("Imagine you have an immensely concentrated protein solution.")
            disp("Then you need to add more ligand to bind all proteins compared to when you have very little protein.")
            disp("Using the power of math, you can derive that approximately 9*KD + protein concentration is needed")
            disp("to get 90% of all binding-sites occupied.")
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
        disp("Seems you have not completed the CSP analysis.")
        disp("Type \"calcCSP\" at the command prompt to start it.")
        disp("")
    elseif number == 5 && questionAsked(number) == 0
        disp("")
        disp("Seems you have not completed the CSP analysis.")
        disp("Type \"calcCSP\" at the command prompt to start it.")
        disp("")
    elseif number == 6 && questionAsked(number) == 0
        disp("")
        disp("Seems you did not determine the KD.")
        disp("Type \"getKD\" at the command prompt to start the analysis.")
        disp("")
    elseif number == 7 && questionAsked(number) == 0
        % summary of the practical
        disp("")
        disp("QUESTION 7.")
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
        clc
        disp("")
        finalScore = 100*score/(10*numQuestions);
        printf("+++++++++++++++++++++++++++++++++++++++++++++++\n")
        printf("++                                           ++\n")
        printf("++     This is the end of the practical.     ++\n")
        printf("++                                           ++\n")
        printf("++     You have a final score of %3.0f/100     ++\n", finalScore)
        printf("++     You got %3d points out of %3d         ++\n", score, numQuestions*10)
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
        disp("protein-protein interactions.")
        disp("")
        disp("Hope you enjoyed it!")
        disp("")
        disp("")
        disp("One more thing:")
        disp("")
        junk=input("<>","s");
        clc
        disp("")
        disp("Send a figure of your titration spectra and the details of your system")
        disp("to your instructor.")
        disp("")
        disp("Make sure the whole spectrum is shown (issue \"zoomFull\" if this is not the case).")
        disp("Make sure all spectra and peak labels are visible (issue \"plotAll\" if this is not the case).")
        disp("")
        disp("Now save your results with the \"saveResults\" command.")
        disp("It will put two figures and a text file in your working directory.")
        disp("")
        disp("Please do not use the save option from the figure window!")
        if sendEmail == 1
            disp("Send these files to:")
            disp("")
            printf("        %s\n", instructorMail)
        else
            disp("Upload these files in the assignment in the electronic learning environment")
            disp("as indicated by your instructor")
         end
        disp("")
        disp("Once you have sent the files you can close this program by typing \"goodbye\"")
        disp("")
        questionAsked(7) = 1;
    elseif questionAsked(number) == 1
        disp("")
        disp("Ha! We don't play that way.")
        disp("You already answered this question ...")
        disp("")
    else
        printf("Uh, I don't know question %d.\n", number)
    end

endfunction
