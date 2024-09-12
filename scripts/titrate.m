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
    % added something but did not record or process the spectrum succesfully
    disp("")
    disp("Something is wrong. Your spectrum is empty. Check with your instructor.")
    disp("It seems you still need to record and process the HSQC of the current sample.")
    disp("Record and process the spectrum using \"zg\" and \"xfb\".")
    disp("Then you can do a new addition.")
    disp("")
else
    % proceed to actual titration
    clc
    disp("***      5. Titration with ligand      ***")
    disp("")
    if titrationPoint == 1 && plotPoints == 1
        % first point additional info
        if easyMode > 1
            disp("Try to space your additions such that in about 7 steps you go from 0% bound to 90-95% bound.")
        else
            disp("Try to space your additions such that in about 7 to 10 steps you go from 0% bound to 90-95% bound.")
        end
        disp("Take a look at the \"report\" command output after each addition to judge how much you need to add.")
        disp("")
        disp("IRL you obviously don't have this information and you would only judge the change in the spectra.")
        disp("Keep repeating adding ligand (\"titrate\"), recording and processing the spectrum (\"zg\", \"xfb\"")
        disp("until you do not see significant changes in the spectrum anymore.")
        if affinityValue < 1e-4 && easyMode > 0
            disp("")
            disp("Since the affinity for you system is rather high, do the following:")
            disp("Make sure to record spectra after adding each time 10 or 20% ligand")
            disp("and make sure to also include few spectra around 100% of ligand added, e.g. 90%, 95%, 110% etc.")
            disp("This is important to get a proper estimate for the KD")
            disp("You can use the \"report\" command to keep track of where you are in the titration.")
            disp("")
        end
        if affinityValue > 1e-3 && easyMode > 0
            disp("")
            disp("Since the affinity for you system is rather low, try to aim for at least 80% bound.")
            disp("This is important to get a proper estimate for the KD")
            disp("Remember that you need to add increasingly more ligand to get all the protein bound to ligand.")
            disp("You can use the \"report\" command to keep track of where you are in the titration.")
            disp("")
        end
        disp("")
        junk=input("<>","s");
        disp("")
    end
    % below happens for all points
    printf("Your sample now contains %.2f mM of ligand\n", lConc)
    printf("this is %.2f equivalents of ligand compared to protein\n", molEq)
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
            disp("or restart the titration by making a new sample (\"makeSample\").")
            disp("")
        else
            % sensible input so proceed
            if molEq + str2num(molAdd) >= 1
                disp("")
                if easyMode == 3  && questionAsked(3) == 0
                    question(3)
                elseif questionAsked(4) == 0 && easyMode == 2
                    question(4)
                elseif questionAsked(6) == 0 && easyMode < 2
                    question(6)
                end
            end
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
                disp("using \"makeSample\"")
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
