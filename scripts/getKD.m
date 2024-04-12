% getKD.m

% this will only work if easyMode is >=1, and slow exchange situations have been excluded

% easyMode = 1 : this is question 10
% easyMode = 2 : this is question 7
% easyMode = 3 : this is question 6

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
    if questionAsked(kdq) == 0
        clc
        disp("")
        printf("QUESTION %d.\n", kdq)
        disp("")
        disp("Super, you're ready for the second and last objective,")
        disp("that is determination of the binding affinity.")
        disp("")
        disp("This is done by using the peak displacement as function of ligand to extract a binding curve")
        disp("and fit it to get the dissociation constant, KD.")
        disp("")
        disp("To do this, identify a peak that has a clear step-wise displacement during the titration,")
        disp("and can be seen at all titration steps.")
        disp("")
        disp("When asked for a peak to focus on, specify the residue number only!")
        disp("")
    end
    if plotPoints < titrationPoint
        disp("First, make sure you see all spectra again by typing \"overlayAll\" at the prompt.")
        disp("")
    else
        peakSelect = input("For which peak to do you want to extract a binding curve? ","s");
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
        else
            disp("")
            disp("This peak is a good choice.")
            disp("")
            figure(2)
            peakNumberKD = str2num(peakSelect);
            % calculate proper box for zooming and display zoomed region
            if ppmaxis == 1
                pcHp = wHvppm(peakNumberKD) - 0.5*dwHvppm(peakNumberKD);       % 1H  peak center of free and bound state
                pcNp = wNvppm(peakNumberKD) - 0.5*dwNvppm(peakNumberKD);       % 15N peak center of free and bound state
                boxHp = abs(0.5*dwHvppm(peakNumberKD)) + 0.05;
                boxNp = abs(0.5*dwNvppm(peakNumberKD)) + 1.00;
                axis([pcHp-boxHp pcHp+boxHp pcNp-boxNp pcNp+boxNp]);
            else
                pcH = (wHv(peakNumberKD) + 0.5*dwHv(peakNumberKD))/(2*my_pi);       % 1H  peak center of free and bound state
                pcN = (wNv(peakNumberKD) + 0.5*dwNv(peakNumberKD))/(2*my_pi);       % 15N peak center of free and bound state
                boxH = abs(0.5*dwHv(peakNumberKD)/(2*my_pi)) + 100;
                boxN = abs(0.5*dwNv(peakNumberKD)/(2*my_pi)) + 100;
                axis([pcH-boxH pcH+boxH pcN-boxN pcN+boxN]);
            end
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
            disp("When the cursor is back in selection mode is shows up as a big white plus sign.")
            disp("")
            disp("And click slowly!")
            disp("")
            junk=input("<>","s");
            disp("")
            CSP_o =[];
            for ss=1:tp
                % display only the spectrum of this titration point
                hold off
                colorIdx = mod(ss-1,length(colorPlot))+1;
                if ppmaxis == 1
                    contour(asHppm, asNppm, plotSpectra(:,:,ss), cntLvls, 'linecolor',colorPlot(colorIdx,:));
                    axis([pcHp-boxHp pcHp+boxHp pcNp-boxNp pcNp+boxNp]);
                    grid on
                    xlabel('1H (ppm)')
                    ylabel('15N (ppm)')
                    set(gca,'XDir','reverse')
                    set(gca,'YDir','reverse')
                else
                    contour(asH, asN, plotSpectra(:,:,ss), cntLvls, 'linecolor',colorPlot(colorIdx,:));
                    axis([pcH-boxH pcH+boxH pcN-boxN pcN+boxN]);
                    grid on
                    xlabel('1H (Hz)')
                    ylabel('15N (Hz)')
                end
                % pick centre peak, return x y
                disp("")
                printf("Pick the center of peak %d in spectrum no. %d  (%s) \n", peakNumberKD, ss, colorPlot(mod(ss-1,length(colorPlot))+1))
                [x_s, y_s, buttons] = ginput(1);
                if ss == 1
                    x_f = x_s;
                    y_f = y_s;
                end
                % store coordinates in vector
                H_CSP = x_s - x_f;
                N_CSP = y_s - y_f;
                if ppmaxis == 1
                    CSP_o   = [ CSP_o sqrt(H_CSP^2 + (N_CSP/5)^2)];
                else
                    CSP_o   = [ CSP_o sqrt(H_CSP^2 + N_CSP^2)];
                end
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
            if ppmaxis == 1
                ylabel("weighted chemical shift perturbation (ppm)")
            else
                ylabel("peak displacement (Hz)")
            end
            title("binding curve","fontweight","bold")
            hold on
            disp("The binding curve is shown in Figure 6.")
            disp("")
            junk=input("<>","s");
            clc
            disp("")
            disp("Now type any key to start fitting this curve...")
            disp("")
            junk=input("<>","s");
            nu = time();
            a=1;
            while time() <= nu + 2
                a = a + 1;
            end
            disp("")
            disp("Done! The best-fit curve will be shown in blue.")
            disp("")
            fitCurve
            plot(lConcv, CSP_c, 'b-;fit;')
            h = legend("location", "southeast");
            disp("")
            disp("Best-fit value for the dissociation constant is:")
            if KD_fit > 1
                printf("\t  KD = %.2f mM\n", KD_fit)
            elseif KD_fit > 1e-3
                printf("\t  KD = %.0f uM\n", KD_fit*1e3)
            else
                printf("\t  KD = %.0f nM\n", KD_fit*1e6)
                disp("")
                disp("As you can see, the affinity is too high to get a reliable estimate from this data.")
                disp("In this case explicit fitting of the line broadening during the titration")
                disp("would be necessary to get accurate KD estimate.")
            end
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
            disp("The actual binding curve is shown in green.")
            if ppmaxis == 1
                CSP_p = cConcv./pConcv.*( sqrt( (dwHvppm(peakNumberKD))^2 + (dwNvppm(peakNumberKD)/(5))^2 ) );
            else
                CSP_p = cConcv./pConcv.*( sqrt( (dwHv(peakNumberKD)/(2*my_pi))^2 + (dwNv(peakNumberKD)/(2*my_pi))^2 ) );
            end
            plot(lConcv, CSP_p, 'g-;actual;')
            disp("")
            if getkdTime == 0 && (easyMode >=1 && questionAsked(kdq) == 0 )
                if abs((KD_fit - KD_real)/KD_real) < 0.5
                    disp("Good job, you are within 2-fold of the true KD. You get 10 points.")
                    score = score + 10;
                else
                    if ligandClass == 1 && koff < 5000 && beNice == 1
                        disp("")
                        disp("Because your titration is close to intermediate exchange, ")
                        disp("this type of binding curve analysis is not exact and your fitted KD is quite off.")
                        disp("You can try to do the anaysis again using a peak that is more in fast exchange.")
                        disp("")
                    else
                        disp("The KD determined from the fit is a bit off unfortunately.")
                        disp("Ask your instructor to have a look at it.")
                        
                    end
                    disp("Still 10 points for the effort.")
                    score = score + 10;
                end
            else
                if abs((KD_fit - KD_real)/KD_real) < 0.5
                    disp("Good job, you are within 2-fold of the true KD which is good enough for now.")
                    disp("To get accurate KDs one best analyzes the lineshapes and peak displacements")
                    disp("together, and of course the protein and ligand concentrations need to be correct.")
                else
                    disp("The KD determined from the fit is a bit off unfortunately.")
                    disp("Ask your instructor to have a look at it.")
                end
            end
            getkdTime = getkdTime + 1;
            disp("")
            junk=input("<>","s");
            clc
            disp("")
            questionAsked(kdq)=1;
            if easyMode == 1
                disp("Now I still have two questions for you.")
                disp("First, type \"question(11)\" at the command prompt.")
            else
                printf("Now it is time for the final question. Type \"question(%d)\" at the command prompt.", kdq+1)
            end
            disp("")
        end
    end
end
