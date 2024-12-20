% titrate.m
%
% Student selects molar ratio of protein:ligand
% works in molar ratios to ease the decision making
% molEq contains total equivalents added
% molAdd is current addition

% echo to student

if titrationPoint == 0
    disp("")
    disp("First make a sample by typing \"makeSample\".")
    disp("")
elseif titrationPoint == 1 && plotPoints == 0
    disp("")
    disp("First record the HSQC spectrum of the free protein.")
    disp("Load the parameters of the HSQC experiment: rpar(\"HSQC\").")
    disp("Record and process the spectrum using \"zg\" and \"xfb\".")
    disp("")
elseif titrationPoint > 1 && length(size(allSpectra)) == 2
    % added something but did not record or process the spectrum
    disp("")
    disp("You still need to record and process the HSQC of the current sample.")
    disp("Record and process the spectrum using \"zg\" and \"xfb\".")
    disp("Then you can do a new addition.")
    disp("")
elseif titrationPoint > 1 && length(size(allSpectra)) == 3 && size(allSpectra)(length(size(allSpectra))) < titrationPoint
    % added something but did not record or process the spectrum
    disp("")
    disp("You still need to record and process the HSQC of the current sample.")
    disp("Record and process the spectrum using \"zg\" and \"xfb\".")
    disp("Then you can do a new addition.")
    disp("")
elseif titrationPoint >= 1 && max(max(allSpectra(:,:,titrationPoint))) == 0
    % check for empty spectrum - should check all spectra as well
    disp("")
    disp("Something is wrong. Your spectrum is empty. Check with your instructor.")
    disp("It seems you still need to record and process the HSQC of the current sample.")
    disp("Record and process the spectrum using \"zg\" and \"xfb\".")
    disp("Then you can do a new addition.")
    disp("")
else
    % proceed to actual titration
    if plotPoints > 1 && min(max(max(allSpectra))) == 0
        % catch empty spectra: two or more spectra should be plotted and one has max of zero
        disp("")
        disp("Something is wrong. One of your spectrum is empty.")
        printf("You have %d spectra recorded, below the maximum for each:\n",plotPoints)
        max(max(allSpectra))
        disp("Check with your instructor.")
        disp("You can simply continue, although the analysis won't work as well.")
        disp("You could also restart the titration by making a new sample (\"makeSample\")")
        disp("")
    end
    if titrationPoint == 1 && plotPoints == 1
        % first point additional info
        clc
        disp("")
        disp("*----------------------------------------------------------*")
        if easyMode == 3
            disp("***         STEP 4 of 5: TITRATE TO BOUND STATE          ***")
        else
            disp("***         STEP 5 of 6: TITRATE TO BOUND STATE          ***")
        end
        disp("*----------------------------------------------------------*")
        disp("")
        disp("You will now add ligand to the protein sample in steps,")
        disp("and record the protein fingerprint spectrum at each step until the protein is fully bound.")
        disp("")
        disp("Keep repeating adding ligand (\"titrate\"), recording and processing the spectrum (\"zg\", \"xfb\")")
        disp("until you do not see significant changes in the spectrum anymore.")
        disp("")
        disp("To make this a bit easier for you, you can take a look at the output from the \"report\" command")
        disp("to see how much bound state protein you have and to judge how much you need to add.")
        disp("")
        disp("Try to space your additions such that in about 7 to 10 steps you go from 0% bound to 85-95% bound.")
        disp("A progress bar will also roughly show how far you are in the titration.")
        disp("")
        disp("Note that it may be impossible to reach beyond 90% or 95% bound protein, depending on your system.")
        disp("IRL you obviously don't have this information and you would only judge the change in the spectra.")
           if affinityValue < 1e-4 && easyMode > 0
            disp("")
            disp("Since the affinity for your system is rather high, do the following:")
            disp("Make sure to record spectra after adding each time 10 or 20% ligand")
            disp("and make sure to also include few spectra around 100% of ligand added, e.g. 90%, 95%, 110% etc.")
            disp("This is important to get a proper estimate for the KD")
            disp("You can use the \"report\" command to keep track of where you are in the titration.")
            disp("")
        end
        if affinityValue > 1e-3 && easyMode > 0
            disp("")
            disp("Since the affinity for your system is rather low, try to aim for at least 80% bound.")
            disp("This is important to get a proper estimate for the KD")
            disp("Remember that you need to add increasingly more ligand to get all the protein bound to ligand.")
            disp("You can use the \"report\" command to keep track of where you are in the titration.")
            disp("")
        end
        if titrationPoint > 10 && pb < 0.7
            disp("")
            disp("I see you're doing a careful job, great work!")
            disp("Still, is good to increase the amount of ligand you add")
            disp("to speed up the titration.")
            disp("Remember that the binding curve will flatten out toward the end")
            disp("So you'll need to add more and more ligand for the same increase in bound protein.")
            disp("")
        end
        disp("")
        junk=input("<>","s");
        disp("")
    end
    % below happens for all points
    disp("")
    % progress bar to show % bound state protein in 5% steps
    %percentBound = 100*cConcv(titrationPoint)/pConc;
    %progressTitration = round(percentBound/5);
    %emptyBits         = 20 - progressTitration;
    %disp(" * titration progress bar (in steps of 5%) *")
    %disp("       0%                                   100% complete")
    %printf("     [")
    %for i = 1:progressTitration
    %    printf("--")
    %end
    %rintf("%2.0f",round(percentBound/5)*5)
    %for i = 1:emptyBits
    %    printf("  ")
    %end
    %printf("]\n")
    %disp("")
    printf("Your sample now contains %.2f mM of ligand\n", lConc)
    printf("this is %.2f molar equivalents of ligand compared to protein\n", molEq)
    disp("")
    molAdd = input("How many molar equivalents of ligand do you want to add? ","s");
    if length(regexp(molAdd,'[.\d]')) < length(molAdd) || length(molAdd)==0
        disp("")
        disp("Please enter a positive number without units!")
        disp("Type \"titrate\" again to re-enter your values.")
        disp("")
    elseif str2num(molAdd) <= 0
        disp("")
        disp("You should enter a positive number, bigger than 0.")
        disp("Type \"titrate\" again to re-enter your values.")
        disp("")
    else
        % valid input
        if str2num(molAdd) < 0.01 && beNice == 1
            disp("")
            disp("Ah that's very little, add a bit more, at least 1%.")
            disp("Do \"titrate\" again and use more equivalents.")
            disp("")
        elseif str2num(molAdd) > 0.3 && beNice == 1 && titrationPoint == 1 && affinityValue > 1e-5 && affinityValue < 1e-3
            disp("")
            disp("Take it easy, don't add too much in the first shot")
            disp("Better to use 0.1-0.3 equivalents for the first step.")
            disp("Do \"titrate\" again and use fewer equivalents.")
            disp("")
        elseif str2num(molAdd) > 0.1 && beNice == 1 && titrationPoint == 1 && affinityValue < 1e-5
            disp("")
            disp("Take it easy, the affinity is quite high so don't add too much in one shot")
            disp("Don't use more than 10% for the first step. Better to use few % only for the first steps.")
            disp("Do \"titrate\" again and use fewer equivalents.")
            disp("")
        elseif str2num(molAdd) > 0.5 && beNice == 1 && titrationPoint == 1
            disp("")
            disp("Wow, slow down, don't add too much in one shot")
            disp("Don't use more than 20% for the first step. Better to use few % only for the first steps.")
            disp("Do \"titrate\" again and use fewer equivalents.")
            disp("")
        elseif molEq + str2num(molAdd) > (1+easyMode)*100/(proteinConc*initialVolume*ligandMass/1e3)
            % this should pop up when more than x mol of ligand is used
            % total moles (mu mol)= Eq*ProteinConc (mM) *VolumeSample (uL)
            % total gr (ug) = total moles (mu mol) * ligandMass (kDa = gr/ mmol)
            % so 1 eq means proteinConc*initialVolume*ligandMass ugr
            % so 1 eq means proteinConc*initialVolume*ligandMass/1e3 mg
            % so 100 mg means 100/(proteinConc*initialVolume*ligandMass/1e3) equivalents
            % doubled to 200 mg for easyMode
            disp("")
            printf("Ah, you ran out of ligand....you don't have more than %d mg of ligand.\n", (1+easyMode)*100)
            disp("You stop here, analyze the titration using \"report\" and \"calcCSP\",")
            disp("")
        else
            % sensible input so proceed
            % for display
            molAdd = str2num(molAdd);
            molEq = molEq + molAdd;                                                      % total eq. added
            volAdd = molAdd * proteinConc * initialVolume/ligandStock;                   % addition volume in uL
            totalVolume = totalVolume + volAdd;                                          % new total volume
            proteinDilution = initialVolume/totalVolume;                                 % dilution factor of protein
            pConc = proteinDilution*proteinConc;                                         % current protein concentrations
            lConc = ligandStock*(totalVolume-initialVolume)/totalVolume;                 % current ligand concentrations
            % real with 2% experimental error
            molAddReal = (1+0.02*randn)*molAdd;                                                      % include 5% experimental error on actual addition
            molEqReal  = molEqReal + molAddReal;                                                     % total eq. added
            volAddReal = molAddReal * proteinConc * initialVolume/ligandStock;                       % addition volume in uL
            totalVolumeReal = totalVolumeReal + volAddReal;                                          % new total volume
            proteinDilutionReal = initialVolume/totalVolumeReal;                                     % dilution factor of protein
            pConcReal = proteinDilutionReal*proteinConc;                                             % current protein concentrations
            lConcReal = ligandStock*(totalVolumeReal-initialVolume)/totalVolumeReal;                 % current ligand concentrations
            if pConc < 0.005
                disp("")
                disp("You will have a very dilute protein sample after this.")
                disp("There is no point to do this step.")
                disp("Either stop the titration here, and analyze the results")
                disp("using \"report\" and \"calcCSP\" commands,")
                disp("or start again by making a more concentrated sample")
                disp("using \"makeSample\" and then redoing the titration.")
                disp("")
            else
                % dilution is OK so proceed
                titrationPoint = titrationPoint + 1;                    % do the addition
                tp = titrationPoint;
                molEqv(tp) = molEq;
                pConcv(tp) = pConc;
                lConcv(tp) = lConc;
                disp("")
                printf("OK, you have added %.2f equivalents of %s stock.\n", molAdd, acronymLigand)
                disp("")
                disp("New sample conditions:")
                printf("Volume                     : %.2f (uL)\n", totalVolume)
                printf("Concentration protein      : %.2f (mM)\n", pConc)
                printf("Concentration ligand       : %.2f (mM)\n", lConc)
                printf("Molar ratio protein/ligand : %.2f     \n", molEq)
                % now calculate new concentrations
                calcEquilibriumConcSingleSite       % calculate free/bound protein (pa/pb)
                cConcv(titrationPoint) = C;         % store concentration complex
                if cConcv(titrationPoint) > pConcv(titrationPoint)
                    disp("")
                    disp("Hmm, wait a second, something is wrong here...")
                    printf("[complex] is %.3f\n",cConcv(titrationPoint))
                    printf("[protein] is %.3f\n",pConcv(titrationPoint))
                    disp("Go ask your instructor.")
                    disp("")
                    junk=input("<>","s");
                    disp("")
                end
                if cConcv(titrationPoint) == 0 && titrationPoint > 1
                    disp("")
                    disp("Hmm, wait a second, something is wrong here...")
                    printf("[complex] is %.3f\n",cConcv(titrationPoint))
                    printf("[ligand] is %.3f\n",lConcv(titrationPoint))
                    disp("Go ask your instructor.")
                    disp("")
                    junk=input("<>","s");
                    disp("")
                end
                % do the question on how far to go if more than 1 eq. added
                if molEq >= 1
                    disp("")
                    if easyMode == 3  && questionAsked(3) == 0
                        question(3)
                    elseif questionAsked(4) == 0 && easyMode == 2
                        question(4)
                    elseif questionAsked(6) == 0 && easyMode < 2
                        question(6)
                    end
                end
                buildExchangeMatrix % update exchange matrix
                pbVectorActual = [pbVectorActual pb];  % store actual pb -- only update after titrate!
                if proteinDilution < 0.3 || pConc < 0.1 && easyMode > 1
                    disp("")
                    disp("Now start the HSQC experiment again.")
                    disp("Btw, you may want to use more scans from now on,")
                    disp("since you're sample is so diluted.")
                    disp("Use \"eda\" to adjust ns then run the experiment using \"zg\".")
                    disp("")
                elseif proteinDilution < 0.3 || pConc < 0.05 && easyMode > 1
                    disp("")
                    disp("Now start the HSQC experiment again.")
                    disp("Btw, you may want to use more scans from now on,")
                    disp("since you're sample is so diluted.")
                    disp("Use \"eda\" to adjust ns then run the experiment using \"zg\".")
                    disp("")
                else
                    disp("")
                    disp("Now start the HSQC experiment again by typing \"zg\" at the command prompt.")
                    disp("If you want to change your addition, you can then do that -only now- by issuing \"unAdd\".")
                    disp("")
                end
            end % check dilution
        end % check sensible input
    end % check valid input
end % check whether titrate is valid next step
