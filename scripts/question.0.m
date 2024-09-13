% question.0.m
% question file for easyMode = 0

function question(number)

global score S2Values koff numPeaks dwNv dwHv questionPoints questionAsked affinityRange yourName cq sendEmail ligandClass

    disp("")
    if number == 1 && questionAsked(number) == 0
        disp("")
        if ligandClass > 0
            disp("You're investigating an interaction between two proteins.")
        else
            disp("You're investigating the interaction between a protein and a smaller molecule.")
        end
        disp("")
        disp("QUESTION 1.")
        disp("What labeling strategy is best to use? Also consider costs.")
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
    elseif number == 2 && questionAsked(number) == 0
        disp("QUESTION 2.")
        disp("For which flip-angles of the pulse will you observe zero signal and for which maximum positive signal?")
        disp("    A. Zero at 180, 360 etc., and maximum at 90, 270, 450 degree  ...")
        disp("    B. Zero at 180, 360 etc., and maximum at 90, 450 degree...")
        disp("    C. Zero at 360, 720 etc., and maximum at 90, 270, 450 degree...")
        disp("    D. Zero at 360, 720 etc., and maximum at 90, 450 degree...")
        disp("")
        answer2 = input("Enter your answer: ","s");
        answer2 = checkAnswer(answer2);
        score   = calcScore(answer2, score, "B", questionPoints);
        junk=input("<>","s");
        disp("")
        disp("EXPLANATION:")
        disp("There will be no signal at 180, 360, 540 degree, etc. Maximum signal for 90, 450 degree, etc.")
        disp("And minimum signal for 270, 630 degree etc. So B is the right answer.");
        disp("")
        junk=input("<>","s");
        disp("");
        disp("NEXT:")
        disp("As it is easier to check for zero of a sinoid signal than a maximum,")
        disp("your task is to identify the pulse length value at which you get a zero-crossing")
        disp("corresponding to a 360 degree rotation of the magnetization.")
        disp("")
        questionAsked(2)=1;
    elsef number == 3 && questionAsked(number) == 0
        disp("")
        disp("QUESTION 3.")
        disp("The polarization transfer element in the HSQC is the INEPT, which contains this")
        disp("spin-echo element: tau-180(1H)/180(15N)-tau. What is the optimal value of tau?")
        disp("The 1JNH coupling constant is -92 Hz for backbone amides in proteins.")
        disp("    A. less than 2.72 ms")
        disp("    B. 2.72 ms")
        disp("    C. less than 5.43 ms")
        disp("    D. 5.43 ms")
        disp("")
        answer3 = input("Enter your answer: ","s");
        answer3 = checkAnswer(answer3);
        score   = calcScore(answer3, score, "A", questionPoints);
        questionAsked(3)=1;
        junk=input("<>","s");
        disp("")
        disp("EXPLANATION:")
        disp("A. is the correct answer. Ignoring relaxation tau should be 1/(4*J),")
        disp("so 1/(4*92)=2.72 ms. Due to the decay of transverse relaxation, the net highest");
        disp("polarization transfer will be obtained at slightly shorter tau values.")
        disp("Here tau is preset to 2.72 ms.")
        disp("If you want, you can change it by typing at the command line:")
        disp("")
        disp("tau= xx          [where xx is the value you want in seconds]")
        disp("")
        junk=input("<>","s");
        %clc
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
        disp("    B. Increasing the length of the acquisition time, decreases the resolution.")
        disp("       Increasing the number of scans by factor of 2, increases the signal-to-noise by sqrt(2).")
        disp("    C. Increasing the length of the acquisition time, increases the resolution.")
        disp("       Increasing the number of scans by factor of 2, increases the signal-to-noise by 2.")
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
        disp("The sensitivity (signal-to-noise) increases as the square-root of the number of scans.")
        disp("Both signal and noise accumalate but due to the random nature of the noise, it adds up")
        disp("not linearly, but as the square-root.")
        disp("")
        junk=input("<>","s");
        disp("")
        disp("Now rerecord the HSQC making sure it has a good S/N and good resolution.")
        disp("Then I have a final question for you before you can really start with the titration.")
        disp("So first use \"eda\" to set-up your HSQC, then \"zg\" to run it, and \"xfb\" to process it.")
        disp("")
        questionAsked(4) = 1;
    elseif number == 5 && questionAsked(number) == 0
        [val, minS2peak] = min(S2Values);
        [val, maxS2peak] = max(S2Values);
        disp("QUESTION 5.")
        printf("Peak %d has a higher intensity than peak %d. How can this be explained?\n", minS2peak, maxS2peak)
        %printf("    A. Peak %d has a higher intensity, because it has a bigger linewidth, which means\n", minS2peak)
        %printf("       that for this amide J(0) is smaller, which means it experiences a smaller\n")
        %printf("       rotation correlation time, which means that has higher internal dynamics.\n")
        %printf("    B. Peak %d has a higher intensity, because it has a bigger linewidth, which means\n", minS2peak)
        %printf("       that for this amide J(0) is bigger, which means it experiences a higher\n")
        %printf("       rotation correlation time, which means that has lower internal dynamics.\n")
        %printf("    C. Peak %d has a higher intensity, because it has a smaller linewidth, which means\n", minS2peak)
        %printf("       that for this amide J(0) is smaller, which means it experiences a smaller\n")
        %printf("       rotation correlation time, which means that has higher internal dynamics.\n")
        %printf("    D. Peak %d has a higher intensity, because it has a smaller linewidth, which means\n", minS2peak)
        %printf("       that for this amide J(0) is bigger, which means it experiences a higher\n")
        %printf("       rotation correlation time, which means that has lower internal dynamics.\n")
        printf("    A. Peak %d experiences more internal dynamics, which means that effectively it is like a smaller molecule,\n", minS2peak)
        printf("       which means its transverse magnetization will relax faster and thus have bigger linewidths and higher peak intensity\n")
        printf("    B. Peak %d has a higher intensity, because it is the signal of more protons.\n", minS2peak)
        printf("    C. Peak %d experiences more internal dynamics, which means that effectively it is like a smaller molecule,\n", minS2peak)
        printf("       which means its transverse magnetization will relax slower and thus have smaller linewidths and higher peak intensity\n")
        printf("    D. Peak %d has a higher intensity, because it just happens to be so due to the noise.\n", minS2peak)
        disp("")
        answer5 = input("Enter your answer: ","s");
        answer5 = checkAnswer(answer5);
        score   = calcScore(answer5, score, "C", questionPoints);
        junk=input("<>","s");
        disp("")
        disp("EXPLANATION:")
        %disp("C is right here. The differences in peak intensities are caused by differences in transverse")
        %disp("relaxation rates. These can be different due to different local dynamics. For instance, the")
        %disp("termini will be more floppy, more dynamic than the folded core of the protein. So for the")
        %disp("floppy bits, the local rotational correlation time is lower, thus the spectral density J(0)")
        %disp("will be lower and this is the dominant spectral density for transverse relaxation in big molecules.")
        %disp("Thus the relaxation rate will be lower and the linewidth smaller for the floppy parts.")
        disp("C is right here. The differences in peak intensities are caused by differences in local dynamics.")
        disp("For instance termini will be more floppy, more dynamic than the folded core of the protein.")
        disp("Floppy bits will behave like small molecules and have sharper, more intense lines.")
        questionAsked(5) = 1;
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
            %disp("First: P+L <-> PL, KD = [P][L]/[PL]")
            %disp("Suppose 90% saturation: [PL] = 0.9Ptot and [P]=0.1*Ptot,")
            %disp("where Ptot is the total protein concentration [P]+[PL].")
            %disp("Then KD = 0.1*Ptot*[L]/(0.9*Ptot) or [L] = 9*KD.")
            %disp("Since [L]=Ltot-[PL] is follows that Ltot=9*KD + 0.9*Ptot.")
            %disp("Thus, one needs to add approximately 9*KD + protein concentration")
            %disp("to get 90% of all binding-sites occupied.")
            %disp("So A is the right answer.");
            disp("Obviously the ligand concentration needed to saturate the protein depends on the affinity.")
            disp("It also depends on your protein concentration.")
            disp("Imagine you have an immensely concentrated protein solution.")
            disp("Then you also need to add more ligand to bind all proteins compared to a situation")
            disp("where you have very little protein.")
            disp("Using the power of math, you can derive that one needs to add")
            disp("approximately 9*KD + protein concentration to get 90% of all binding-sites occupied.")
            disp("So A is the right answer.");
            disp("")
            junk=input("<>","s");
            disp("")
            printf("In your system the KD is in the %s range.\n", affinityRange)
            disp("So continue the titration until you are close to 10*KD+protein concentration,")
            disp("and/or you see no more significant changes in the spectrum")
            disp("You can also take a peek at the %bound protein using \"report\"...")
            disp("")
            disp("When you have all your spectra, issue \"calcCSP\" to analyse the changes in the spectra.")
            disp("")
            junk=input("<>","s");
            questionAsked(6)=1;
    % calcCSP has question 7 and 8
    elseif number == 7 && questionAsked(number) == 0
        disp("")
        disp("Seems you have not completed the CSP analysis.")
        disp("Type \"calcCSP\" at the command prompt to start it.")
        disp("")
    elseif number == 8 && questionAsked(number) == 0
        disp("")
        disp("Seems you have not completed the CSP analysis.")
        disp("Type \"calcCSP\" at the command prompt to start it.")
        disp("")
    elseif number == 9 && questionAsked(number) == 0
        % judge exchange regime
        disp("QUESTION 9.")
        disp("")
        disp("I will now ask you to classify for each peak whether it is ")
        disp("fast, intermediate or slow exchange.")
        disp("For every peak, all 1D slices of that peak in all spectra will be shown.")
        disp("")
        junk=input("<>","s");
        score=score+1
        disp("")
        for p=1:numPeaks
            peakLabel = strcat(aa_string(p),num2str(p));
            showSlices(p,"b")
            printf("Peak %s:\n", peakLabel)
            disp("    A. does not experience any exchange.")
            disp("    B. is in slow exchange.")
            disp("    C. is in intermediate exchange.")
            disp("    D. is in fast exchange.")
            disp("")
            answer9 = input("Enter your answer: ","s");
            answer9 = checkAnswer(answer9);
            % calculate true dw/kex ratio's
            aH = abs(dwHv(p))/(2*koff);
            aN = abs(dwNv(p))/(2*koff);
            if abs(dwHv(p)) < 6 && abs(dwNv(p)) < 6
                tru9    = "A";
            % if peak shows neglible broadening it must be fast-ish exchange <0.2 for both
            % if peak dissappears and reappers without shifting it must be slow-ish exhange, should not occur here
            % if peaks shifts but broadens a lot around midpoint is is intermediate, at least 1 >0.2
            elseif aH < 0.2 && aN < 0.2
                tru9    = "D";
            elseif aH > 10 || aN > 10
                tru9    = "B";
            else
                tru9    = "C";
            end
            score   = calcScore(answer9, score, tru9, 1);
            disp("")
            if tru9 !="A"
                disp("EXPLANATION")
                disp("For a protein-titration experiment, it is the spectrum at")
                disp("the midpoint that determines the exchange regime.")
                disp("Thus, if the peak is only shifting without clear broadening, it is in fast exchange.")
                disp("If it shifts gradually during the titration but also broadens significantly")
                disp("around the midpoint, and then increases in intensity upon addition of more")
                disp("ligand, it is in intermediate exchange.")
                disp("If the peak dissappears at the original location and reappears at a new spot,")
                disp("it is in slow exchange.")
                disp("Inspect the information below, specifically ")
                disp("the ratio of dw (=chemical shift difference in rad s-1) to kex (the exchange rate).")
                peakInfo(p)
            end
            junk=input("<>","s");
            %clc
        end
        disp("")
        disp("Time for the final question: estimate the life-time of the complex,")
        disp("or in other words the off-rate for the dissocation of the complex.")
        disp("Look up the chemical shift differences for some peaks to estimate koff")
        disp("based on the observed exchange regime.")
        disp("Use \"peakInfo\" to get the shift differences.")
        disp("When you're ready type \"question(10)\".")
        disp("")
        questionAsked(9) = 1;
    elseif number == 10 && questionAsked(number) == 0;
        % estimate off rate now directly and fixed ranges.
        disp("QUESTION 10.")
        disp("Estimate the off-rate, koff, using an educated guess.")
        disp("    A. koff is < 50 s-1")
        disp("    B. koff is between 100 and 5000 s-1")
        disp("    C. koff is > 10000 s-1")
        disp("")
        answer10 = input("Enter your answer: ","s");
        answer10 = checkAnswer3(answer10);
        if koff < 50
            tru10 = "A";
        elseif koff > 10000
            tru10 = "C";
        else
            tru10 = "B";
        end
        score    = calcScore(answer10, score, tru10, questionPoints);
        disp("")
        disp("EXPLANATION")
        disp("At the titration midpoint the exchange-rate is 2*koff")
        disp("and determines the exchange regime: slow, intermediate or fast")
        disp("So if a peak is in slow exchange, you know that 2*koff << chemical shift difference of that peak")
        disp("Likewise, if that peak shifts, but also broadens signficantly, ")
        disp("you know that 2*koff ~ chemical shift difference")
        disp("and if the peak only shifts, 2*koff must be >> chem. shift diff.")
        disp("")
        printf("For your system the koff is %d s-1, which means that\n", koff)
        if koff > 10000
            printf("the complex has a life time of 1/koff ~ %d us.\n", 1/koff*1e6);
        elseif koff >100
            printf("the complex has a life time of 1/koff ~ %.2f ms.\n", 1/koff*1000);
        else
            printf("the complex has a life time of 1/koff ~ %.0f ms.\n", 1/koff*1000);
        end
        disp("")
        junk=input("<>","s");
        %clc
        questionAsked(number) = 1;
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
