% getKD.m

% this will only work if easyMode is >=1, and slow exchange situations have been excluded

% easyMode = 1 : this is question 10
% easyMode = 2 : this is question 7
% easyMode = 3 : this is question 6

continueKDQuestion = "y";
if easyMode == 0
    disp("")
    disp("This analysis won't work in your case most likely.")
    disp("")
    junk=input("<>","s");
    disp("")
end
% set correct question number
if easyMode == 1
       kdq = 10;
elseif easyMode == 2
    kdq = 7;
else
    kdq = 6;
end
% save score at start of this analysis
oriScore = score;
% check whether done before
if questionAsked(kdq) == 1 && easyMode >=1
    disp("")
    disp("You already did this analysis.")
    disp("You can do it again but you won't get points for it...")
    disp("")
    disp("")
    junk=input("<>","s");
    disp("")
end
% make sure to only work if you're ready e.g. calcCSP has been asked
if easyMode >= 1 && questionAsked(kdq-1) == 0 
    disp("")
    disp("First finish your titration experiment and")
    disp("do the chemical shift perturbation analysis.")
    disp("Type \"report\" to see how far you are in the titration.")
    disp("Type \"calcCSP\" to start the chemical shift perturbation analysis.")
    disp("")
elseif affinityValue*1e3 < proteinConc && molEq < 1.5
    % check whether plateau has been reached in particular for high affiniity binders
    disp("")
    disp("Even though the affinity is rather high, and your protein is nearly completely bound to ligand,")
    disp("it is better to record an additional point to measure the binding plateau.")
    disp("Type \"report\" to see how far you are in the titration.")
    disp("Type \"titrate\" to add more ligand, increase to at least 1.5 equivalents of ligand.")
    disp("")
else
    if questionAsked(kdq) == 0 && getkdTime == 0
        clc
        disp("")
        disp("Super, you're ready for the second and last objective,")
        disp("that is determination of the binding affinity.")
        disp("")
        disp("This is done by using the peak displacement as function of ligand to extract a binding curve")
        disp("and fit it to get the dissociation constant, KD.")
        disp("")
        disp("You can get maximum 5 points when you get a good fit and maximum 5 more points if it the fitted KD is good.")
        disp("")
        disp("To start, identify a peak that has a clear step-wise displacement during the titration,")
        disp("and can be seen at all titration steps.")
        disp("")
        disp("When asked for a peak to focus on, specify the residue number only!")
        disp("")
    end
    if plotPoints < titrationPoint
        disp("First, make sure you see all spectra again by typing \"overlayAll\" at the prompt.")
        disp("")
    else
        disp("")
        peakSelect = input("For which peak do you want to extract a binding curve? (Enter number only)","s");
        if length(regexp(peakSelect,'[.\d]')) < length(peakSelect) || length(peakSelect)==0
            disp("")
            disp("Please enter a positive number without units!")
            disp("Type \"getKD\" again to re-enter your values.")
            disp("")
        elseif abs(dwHv(str2num(peakSelect)))/(2*koff) > 0.71 && beNice == 1  % check whether peak is indeed fast /fast-intermediate
            disp("")
            disp("This residue is in slow or intermediate exchange or experiences too much broadening.")
            disp("Type \"getKD\" again and choose another peak.")
            disp("")
            disp("Best to take a peak that a large but gradual peak displacement during the titration,")
            disp("and can be seen at all titration steps.")
            disp("")
        else
            disp("")
            disp("This peak is a good choice.")
            disp("")
            figure(2)
            peakNumberKD = str2num(peakSelect);
            % calculate proper box for zooming and display zoomed region
            pcHp = wHvppm(peakNumberKD) - 0.5*dwHvppm(peakNumberKD);       % 1H  peak center of free and bound state
            pcNp = wNvppm(peakNumberKD) - 0.5*dwNvppm(peakNumberKD);       % 15N peak center of free and bound state
            boxHp = abs(0.5*dwHvppm(peakNumberKD)) + 0.05;
            boxNp = abs(0.5*dwNvppm(peakNumberKD)) + 1.00;
            axis([pcHp-boxHp pcHp+boxHp pcNp-boxNp pcNp+boxNp]);
            disp("The spectrum plot is now zoomed in on this peak.")
            disp("Each spectrum of the titration will be shown, one at a time.")
            disp("")
            junk=input("<>","s");
            % now prompt for picking all peak centers
            % actually need to see only one spectrum at a time otherwise super crowded
            disp("")
            printf("Now left-click the peak center of peak %d in all spectra.\n", peakNumberKD)
            disp("")
            disp("Be sure that the cursor is in selection mode, visible as big white plus sign.")
            disp("Sometimes the cursor changes to zoom mode by itself, visible as blue plus sign inside a circle.")
            disp("If that happens, first deactivate the zoom mode by clicking zoom button in the figure menu bar.")
            disp("When the cursor is back in selection mode it shows up as a big white plus sign.")
            disp("")
            disp("And click slowly!")
            disp("")
            junk=input("<>","s");
            disp("")
            CSP_o =[];
            for ss=1:titrationPoint
                % display only the spectrum of this titration point
                hold off
                colorIdx = mod(ss-1,length(colorPlot))+1;
                contour(asHppm, asNppm, plotSpectra(:,:,ss), cntLvls, 'linecolor',colorPlot(colorIdx,:));
                axis([pcHp-boxHp pcHp+boxHp pcNp-boxNp pcNp+boxNp]);
                grid on
                xlabel('1H (ppm)')
                ylabel('15N (ppm)')
                set(gca,'XDir','reverse')
                set(gca,'YDir','reverse')
                % pick centre peak, return x y
                disp("")
                % check whether we have more points than colors:
                if ss <= length(colorNamesLong)
                    colorSpec = regexprep(colorNamesLong(ss,:), '\W', "");
                 elseif ss <= 2*length(colorNamesLong)
                    % wrap around: there are 11 colors, tp 12 will be color 1
                    cp = ss - length(colorNamesLong);
                    colorSpec = regexprep(colorNamesLong(cp,:), '\W', "");
                elseif ss <= 3*length(colorNamesLong)
                    cp = ss - 2*length(colorNamesLong);
                    colorSpec = regexprep(colorNamesLong(cp,:), '\W', "");
                else
                    cp = ss - 4*length(colorNamesLong);
                    colorSpec = regexprep(colorNamesLong(cp,:), '\W', "");
                end
                printf("Pick the center of peak %d in spectrum no. %d  (%s) \n", peakNumberKD, ss, colorSpec)
                [x_s, y_s, buttons] = ginput(1);
                if ss == 1
                    x_f = x_s;
                    y_f = y_s;
                end
                % store coordinates in vector
                H_CSP = x_s - x_f;
                N_CSP = y_s - y_f;
                CSP_o   = [ CSP_o sqrt(H_CSP^2 + (N_CSP/5)^2)];
            end
            disp("")
            disp("Extracting binding curve ...")
            disp("")
            %pause (0.5)
            % plot
            figure(6)
            hold off
            plot(lConcv, CSP_o, 'ro;observed;')
            h = legend("location", "southeast");
            axis([0 1.05*max(lConcv) 0 1.1*max(CSP_o)])
            % double-check units of ligand concentration is in mM -- see titrate.m
            xlabel("ligand concentration (mM)")
            ylabel("weighted chemical shift perturbation (ppm)")
            title("binding curve","fontweight","bold")
            hold on
            disp("The binding curve is shown in Figure 6.")
            disp("")
            junk=input("<>","s");
            %clc
            disp("")
            disp("Now type any key to start fitting this curve...")
            disp("")
            junk=input("<>","s");
            nu = time();
            a=1;
            while time() <= nu + 2
                a = a + 1;
            end
            fitCurve
            disp("")
            disp("Done! The best-fit curve will be shown in blue.")
            disp("")
            plot(lConcv, CSP_f, 'b-;fit;')
            h = legend("location", "southeast");
            disp("")
            disp("Best-fit value for the dissociation constant is:")
            if KD_fit > 1
                printf("\t  KD = %.2f mM\n", KD_fit)
            elseif KD_fit > 1e-3
                printf("\t  KD = %.0f uM\n", KD_fit*1e3)
            else
                printf("\t  KD = %.0f nM\n", KD_fit*1e6)
            end
            disp("")
            if redChi2 < 1
                disp("Great job, the quality of the fit is very good!")
                disp("You get the maximum 5 points")
                score = score + 5;
                getkdTime = getkdTime + 1;
            elseif redChi2 < 2
                disp("Good job, the quality of the fit is ok!")
                disp("You get 4 points")
                score = score + 4;
                getkdTime = getkdTime + 1;
            elseif redChi2 >= 3
                disp("Hmmm, seems somthing went wrong here...")
                disp("The quality of the fit is very low.")
                disp("Maybe the peak picking went wrong.")
            else
                disp("Ok, the quality of the fit could be better, but let's continue anyway.")
                disp("You get 2 points")
                score = score + 2;
                getkdTime = getkdTime + 1;
            end
            disp("")
            disp("Now let's check against the expected result..")
            disp("")
            junk=input("<>","s");
            disp("")
            % check with actual perfect data
            disp("The actual dissociation constant was:")
            % also convert to mM
            KD_real = affinityValue*1e3;
            if KD_real > 1
                printf("\t  KD = %.2f mM\n", KD_real)
            elseif KD_real < 1e-4
                printf("\t  KD = %.2f nM\n", KD_real*1e6)
            else
                printf("\t  KD = %.0f uM\n", KD_real*1e3)
            end
            disp("")
            % !!! this is assuming fast exchange !!!
            disp("The expected binding curve is shown in green.")
            % this has to be based on actual addition!!
            CSP_s = pbVectorActual.*( sqrt( (dwHvppm(peakNumberKD))^2 + (dwNvppm(peakNumberKD)/5)^2 ) );
            % also scale to observed CSP
            plot(lConcv, CSP_s*max(CSP_f)/max(CSP_s), 'g-;expected;')
            disp("")
            if easyMode >=1 && questionAsked(kdq) == 0
                if redChi2 < 3
                    % good enough fit
                    if abs((KD_fit - KD_real)/KD_real) < 0.2
                        disp("Excellent work, you are within 20% of the true KD. You get 5 more points.")
                        disp("")
                        score = score + 5;
                        questionAsked(kdq)=1;
                        continueKDQuestion = 'n';
                    elseif abs((KD_fit - KD_real)/KD_real) < 0.5
                        disp("Good job, you are within 50% of the true KD. You get 3 more points.")
                        disp("")
                        score = score + 3;
                        questionAsked(kdq)=1;
                        continueKDQuestion = 'n';
                    else
                        if ligandClass == 1 && koff < 5000 && beNice == 1
                            disp("")
                            disp("Because your titration is close to intermediate exchange, ")
                            disp("this type of binding curve analysis is not exact and your fitted KD is quite off.")
                            disp("You can try to do the anaysis again using a peak that is more in fast exchange.")
                            disp("Otherwise just continue.")
                            disp("")
                            disp("")
                            disp("Still, 5 points for the effort.")
                            disp("")
                            score = score + 5;
                            questionAsked(kdq)=1;
                        else
                            disp("The KD determined from the fit is a bit off unfortunately.")
                            disp("Ask your instructor to have a look at it.")
                            disp("You can try to do the anaysis again, or just continue.")
                            disp("")
                            disp("Still, 2 points for the effort.")
                            disp("")
                            score = score + 2;
                            questionAsked(kdq)=1;
                        end
                    end
                else
                    % very poor fit
                    if abs((KD_fit - KD_real)/KD_real) < 0.2
                        disp("Interesting, you are still within 20% of the true KD! You get 5 more points.")
                        disp("Probably the power of compensating random errors...")
                        disp("Ask your instructor to have a look at this surprising result!")
                        score = score + 5;
                        questionAsked(kdq)=1;
                        continueKDQuestion = 'n';
                    elseif abs((KD_fit - KD_real)/KD_real) < 0.5
                        disp("Interesting, you are still within 50% of the true KD. You get 3 more points.")
                        disp("Ask your instructor to have a look at this surprising result!")
                        score = score + 3;
                        questionAsked(kdq)=1;
                        continueKDQuestion = 'n';
                    else
                        if ligandClass == 1 && koff < 5000 && beNice == 1
                            disp("")
                            disp("Because your titration is close to intermediate exchange, ")
                            disp("this type of binding curve analysis is not exact and your fitted KD is quite off.")
                            disp("You can try to do the anaysis again using a peak that is more in fast exchange.")
                            disp("Otherwise just continue.")
                            disp("")
                        else
                            disp("The KD determined from the fit is a bit off unfortunately.")
                            disp("Ask your instructor to have a look at it.")
                            disp("You can try to do the anaysis again, or just continue.")
                            disp("")
                        end
                        % no points
                        questionAsked(kdq) = 1;
                    end % poor fit
                end % fit quality
                % check whether to ask to redo the analysis in case result was very poor
                if continueKDQuestion == 'y'
                    % we need to check whether to redo
                    continueKDQuestion = input("Do you want to redo the KD analysis? y/n: ","s");
                    if continueKDQuestion != "n" && continueKDQuestion != "y"
                        continueKDQuestion = input("Please type y if you want to redo the analyis:","s");
                        if continueKDQuestion != "n" && continueKDQuestion != "y"
                            continueKDQuestion = "n";
                        end
                    end
                    if continueKDQuestion == 'y'
                        questionAsked(kdq) =0;
                        getkdTime =0;
                        score = oriScore;
                        disp("")
                        disp("Type \"getKD\" again to redo the analysis.")
                        disp("")
                    else
                        disp("")
                        printf("OK, now it is time for the final questions. Type \"question(%d)\" at the command prompt.\n", kdq+1)
                        disp("")
                    end
                else
                    % no redo, done here
                    disp("")
                    junk=input("<>","s");
                    disp("")
                    printf("Now it is time for the final questions. Type \"question(%d)\" at the command prompt.\n", kdq+1)
                    disp("")
                end % check redo
            else
                % already done the analysis no point and little feedback, should not happen, only easyMode 0
                if easyMode == 0
                    if abs((KD_fit - KD_real)/KD_real) < 0.5
                        disp("Good job, you are within 50% of the true KD which is good enough for now.")
                        disp("To get accurate KDs one best analyzes the lineshapes and peak displacements")
                        disp("together, and of course the protein and ligand concentrations need to be correct.")
                    else
                        disp("The KD determined from the fit is a bit off unfortunately.")
                        disp("Ask your instructor to have a look at it.")
                    end
                else
                    disp("")
                    printf("To continue to the final questions, type \"question(%d)\" at the command prompt.\n", kdq+1)
                    disp("")
                end
            end
        end
    end
end
