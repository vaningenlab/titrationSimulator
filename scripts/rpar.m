% rpar.m
%
% this function only displays text and sets the expPars variable
% all other experiment settings have to be done outside the function
% otherwise the associated variables will not be available globally

function rpar(expName)
    
    global expPars p1 beNice score questionPoints questionAsked trup easyMode numCalibCheck numCalib
    
    if nargin == 0
        disp("")
        disp("Usage:")
        if easyMode == 0
            disp("rpar(\"find90\") or rpar(\"HSQC\")")
        elseif easyMode == 1 || easyMode == 2
            disp("rpar(\"popt\") or rpar(\"HSQC\")")
        else
             disp("rpar(\"HSQC\")")
        end
        disp("")
    else
        %clc
        % double check for quotes -- not possible
        if strcmp(expName,"HSQC")
            expPars = "HSQC";
            if easyMode < 3 && beNice == 1 && numCalibCheck == 0
                % first check whether p1 is acceptable
                disp("")
                disp("Wait. Let me first double check your 90-degree pulse length ...")
                %pause(0.5)
                disp("")
                junk=input("<>","s");
                disp("")
                p1Err = 0;
                loadHSQC = 0;
                % only if beNice, actual pulse is 7-12 us
                %               180 / 540   25% error  1 us error (~10%)
                % easyMode = 0      x
                % easyMode = 1      x        x                      (more responsibility for student to do correctlys)
                % easyMode = 2      x                      x
                % easyMode = 3 does not have pulse calibration
                if abs(p1-trup*1.5) < 1 && beNice == 1
                    disp("Maybe you found the null for 360+180. The pulse length is usually between 7 and 12 microseconds.")
                    p1Err = 1;
                elseif abs(p1-trup*0.5) < 1 && beNice == 1
                    disp("Maybe you found the null for 180. The pulse length is usually between 7 and 12 microseconds.")
                    p1Err = 1;
                elseif easyMode == 1 && abs(p1-trup)/trup > 0.25 && beNice == 1
                    disp("Hmmm. I'm not so sure about this. Your p1 90-degree pulse seems to miscalibrated.")
                    p1Err = 1;
                elseif easyMode == 1 && abs(p1-trup) > 1 && beNice == 1
                    disp("Hmmm. I'm not so sure about this.")
                    disp("You can continue to the record HSQC but you could also re-check the calibration.")
                    p1Err = 0.5;
                elseif easyMode == 2 && abs(p1-trup)> 1 && beNice == 1
                    disp("Hmmm. I'm not so sure about this. Your p1 90-degree pulse seems to miscalibrated.")
                    p1Err = 1;
                end
                if p1Err == 1
                    % do not continue, but prompt to re-calibrate
                    disp("")
                    printf("You found %.2f us for the 90-degree pulse length,\n", p1)
                    disp("But this is too far off from what the computer tells me...")
                    disp("Go back to the pulse calibration experiment and redo the calibration by typing:")
                    disp("")
                    if easyMode == 0
                        disp("rpar(\"find90\")")
                    else
                        disp("rpar(\"popt\")")
                    end
                    disp("")
                    disp("Ask your instructor for help if necessary.")
                    disp("")
                    % make sure check will be done again
                    numCalibCheck = 0;
                else
                    % within limits of easyMode, ok to continue
                    disp("")
                    % full points if within 0.5us
                    if abs(p1-trup) <= 0.5
                        % easyMode 0 1 2 / always true for easyMode 2 /
                        disp("Alright. You did a good job at the calibration!")
                        printf("You found %.2f us for the 90-degree pulse length,\n", p1)
                        printf("somehow the computer knows it is actually %.2f us.\n", trup)
                        disp("You get 10 points extra!")
                        score = score + 10;
                        loadHSQC = 1;
                    elseif abs(p1-trup) < 1
                        % easyMode 0 1 2 / always true for easyMode 2 /
                        disp("Alright. You did a pretty good job at the calibration!")
                        printf("You found %.2f us for the 90-degree pulse length,\n", p1)
                        printf("somehow the computer knows it is actually %.2f us.\n", trup)
                        disp("Normally, you would need to be more exact, but here it is OK. You get 5 points extra!")
                        if easyMode == 1
                            disp("If you want you go back to the calibration experiment: \"rpar(\"popt\")\".")
                        end
                        score = score + 5;
                        loadHSQC = 1;
                    elseif abs(p1-trup)/trup <= 0.25
                        % easyMode 0 1 / always true for easyMode 1 /
                        if p1Err > 0
                            disp("Still, you did a reasonable job at the calibration!")
                            if easyMode == 1
                                disp("If you want you go back to the calibration experiment: \"rpar(\"popt\")\".")
                            end
                            % can still redo calibration so do not tell the answer
                        else
                            disp("Not bad. You did a reasonable job at the calibration!")
                            printf("You found %.2f us for the 90-degree pulse length,\n", p1)
                            printf("somehow the computer knows it is actually %.2f us.\n", trup)
                            if easyMode == 1
                                disp("If you want you go back to the calibration experiment: \"rpar(\"popt\")\".")
                            end
                        end
                        disp("You get 2 points extra!")
                        score = score + 2;
                        loadHSQC = 1;
                    else 
                        % easyMode 0 
                        disp("Sorry, the pulse calibration is not very good.")
                        printf("You found %.2f us for the 90-degree pulse length,\n", p1)
                        printf("somehow the computer knows it is actually %.2f us.\n", trup)
                        disp("You did not score points here...")
                        disp("Check the calibration again")
                        disp("by typing at the command prompt:")
                        if easyMode == 0
                            disp("rpar(\"find90\")")
                        else
                            disp("rpar(\"popt\")")
                        end
                    end
                    if loadHSQC == 1
                        disp("")
                        junk=input("<>","s");
                        clc
                        disp("")
                        disp("*----------------------------------------------------------*")
                        disp("***         STEP 4 of 6: PROTEIN FREE STATE SPECTRUM     ***")
                        disp("*----------------------------------------------------------*")
                        disp("")
                        disp("Loading experimental setup for {1H-15N}-HSQC experiment ...")
                        nu = time();
                        a=1;
                        while time() < nu + 1
                            a=a+1;
                        end 
                        disp("Loaded! Now setup the acquisition parameters by typing \"eda\" at the command prompt.")
                        disp("")
                        disp("( Remember, the command prompt is when you see :)], the <> symbol is a pause where all input is ignored )")
                        disp("")
                        numCalibCheck = 1;
                        disp("")
                        junk=input("<>","s");
                        disp("")
                    end
                end
            elseif easyMode == 3 || ( easyMode < 3 && numCalibCheck == 1)
                clc
                disp("")
                disp("*----------------------------------------------------------*")
                disp("***         STEP 3 of 5: PROTEIN FREE STATE SPECTRUM     ***")
                disp("*----------------------------------------------------------*")
                disp("")
                disp("Loading experimental setup for {1H-15N}-HSQC experiment ...")
                nu = time();
                a=1;
                while time() < nu + 1
                    a=a+1;
                end 
                disp("Loaded! Now setup the acquisition parameters by typing \"eda\" at the command prompt")
                disp("")
            end % checks HSQC
        elseif strcmp(expName,"find90")
            expPars = "find90";
            clc
            disp("")
            disp("*----------------------------------------------------------*")
            disp("***         STEP 3 of 6: PULSE CALIBRATION               ***")
            disp("*----------------------------------------------------------*")
            disp("")
            disp("Loading 1H 90 degree pulse calibration experiment ...")
            nu = time();
            a=1;
            while time() < nu + 1
                a=a+1;
            end 
            disp("Loaded!")
            disp("")
            disp("In this calibration-experiment you simply apply a pulse of user-defined length")
            disp("starting from equilibrium magnetization and observe the resulting water signal,") 
            disp("as it is the most intense 1H signal.")
            if questionAsked(2) == 0
                disp("")
                question(2)
                junk=input("<>","s");
            end
            disp("")
            disp("To calibrate the pulse length you:")
            disp("\t - enter the value of the pulse length at the command prompt by typing, e.g.:")
            disp("\t   \tp1 = 8")
            disp("\t   ==> note it is p-one not p-el! <==")
            disp("\t - then you start the experiment by typing \"zg\" at the prompt, this will execute a pulse")
            disp("\t   of 4x the value you entered, e.g. 32us in the example above.")
            disp("\t - you then Fourier Transform the FID by typing \"qfp\" at the prompt")
            disp("\t - you examine the signal intensity and if neccessary, ")
            disp("\t   change the p1-value and redo the experiment.")
            disp("")
            disp("The 1H 90 degree pulse varies usually between 7 and 12 microseconds, ")
            disp("depending on the saltiness of your sample buffer.")
            disp("")
        elseif strcmp(expName,"popt")
            expPars = "popt";
            clc
            disp("")
            disp("*----------------------------------------------------------*")
            disp("***         STEP 3 of 6: PULSE CALIBRATION               ***")
            disp("*----------------------------------------------------------*")
            disp("")
            disp("Loading 1H 90 degree pulse calibration experiment ...")
            nu = time();
            a=1;
            while time() < nu + 1
                a=a+1;
            end 
            disp("Loaded!")
            disp("")
            junk=input("<>","s");
            if numCalib == 0
                disp("")
                disp("Calibration of the 90 degree pulse is crucial to make sure your experiments work well,")
                disp("meaning that you get maximum signal and minimal artifacts.")
                disp("")
                disp("In this experiment you do a series of 1Ds each with a different value for ")
                disp("the duration of the 1H pulse.")
                disp("")
                disp("In these spectra you will see only one 1H signal: the water,")
                disp("as it is the most intense 1H signal.")
                disp("")
                junk=input("<>","s");
                disp("")
                disp("The goal is that you determine at what duration of the pulse (called p1)")
                disp("you get a 90 degree rotation of the magnetization and thus maximum signal.")
                disp("")
                disp("The 1H 90 degree pulse length varies usually between 7 and 12 microseconds, ")
                disp("depending on the saltiness of your sample buffer.")
                disp("")
                junk=input("<>","s");
                disp("")
                disp("Let's do the first try of the calibration experiment together.")
                disp("")
                junk=input("<>","s");
                disp("")
            end
            disp("To do the calibration:")
            disp("\t - type \"zg\" at the prompt")
            disp("\t - you are asked for a starting value for the pulse length duration,")
            disp("\t   an increment value and a total number of experiments")
            disp("\t - you examine the result")
            disp("")
         else
            disp("")
            disp("The computer says no.")
            printf("There is no %s experiment.\n", expName)
            disp("Type \"rpar\" without arguments to see which experiments are available.")
            disp("")
         end
    end 
end
