% makeSample.m

% sets: - proteinConc
%       - ligandStock

% assuming standard titration using concentrated stock
% and one NMR sample
% so have to include dilution effects

% performs sanity checks on the chosen concentrations
% - proteinConc:    not higher than x mM depending on size
% - ligandStock:    not higher than x mM depending on size
% - ligandStock:    not lower than x mM given KD
%                   not lower than x mM given dilution

% when sample is made, an HSQC of the free protein needs to be recorded

% echo to student

clc
disp("")
disp("*----------------------------------------------------------*")
if easyMode == 3
    disp("***         STEP 2 of 5: YOUR SAMPLE                     ***")
else
    disp("***         STEP 2 of 6: YOUR SAMPLE                     ***")
end
disp("*----------------------------------------------------------*")
disp("")

if questionAsked(1)==0
    printf("OK, now you need to prepare an NMR sample of your protein %s (%.1f kDa),\n", acronymProtein, proteinMass)
    printf("and a stock solution of your ligand %s (%.1f kDa).\n", acronymLigand, ligandMass)
    disp("")
    disp("Once you have these two samples, you will add the ligand in steps to your NMR sample")
    disp("and monitor the changes in chemical shift of the protein upon binding of the ligand.")
    disp("")
    junk=input("<>","s");
    question(1)
    junk=input("<>","s");
    disp("")
    disp("To make the samples, you simply need to define the protein concentration of your NMR sample,")
    disp("and the concentration of your ligand stock solution.")
    disp("")
    if easyMode >= 2
        disp("The protein concentration in an NMR sample is typically 0.5 to 1 mM.")
    elseif easyMode == 1
        disp("TThe protein concentration in an NMR sample is typically 0.1 to 1 mM.")
    else
        disp("The protein concentration in an NMR sample is usually somewhere between tens of micromolar (uM) and few millimolar (mM).")
    end
    disp("The ligand stock solution needs to be as concentrated as possible to avoid diluting the protein sample too much.")
    disp("")
    if easyMode >= 2
        if ligandClass == 0
            disp("For small molecule ligands, the stock concentration is typically 10 times")
            disp("the expected dissocation constant (KD), so somewhere between 10 and 40 mM.")
            disp("This maximum concentration will depend on the solubility of your ligand.")
        else
            disp("For protein ligands, the stock concentration is typically limited by their solubility,")
            disp("so somewhere between 5 and 15 mM.")
        end
    elseif easyMode == 1
        if ligandClass == 0
            disp("For small molecule ligands, the stock concentration is typically 10-20 times")
            disp("the expected dissocation constant (KD), so somewhere between 10 and 40 mM.")
            disp("This maximum concentration will depend on the solubility of your ligand.")
        else
            disp("For protein ligands, the stock concentration is typically limited by their solubility,")
            disp("luckily yours can be concentrated to 10 mM.")
        end
    end
    disp("")
    junk=input("<>","s");
    disp("")
    disp("Next enter your protein and ligand concentration in units of mM.")
    disp("")
end

continueQuestion = "y"; % continue 
while continueQuestion == "y"
    continueQuestion = "n";
    % read input as string to be able to check whether input is a number
    proteinConc = input("Enter your protein concentration (mM): ","s");
    ligandStock = input("Enter your ligand stock concentration (mM): ","s");
    % check input
    if length(regexp(proteinConc,'[.\d]')) < length(proteinConc) || length(regexp(ligandStock,'[.\d]')) < length(ligandStock) || length(proteinConc) ==0 || length(ligandStock)==0
        continueQuestion = "y";
        disp("")
        disp("Please enter a positive number without units for the concentration")
        disp("")
    else
        proteinConc = str2num(proteinConc);
        ligandStock = str2num(ligandStock);
        % 1 mM of 10 kDa is 10 mg/ml so 5 mg for normal sample
        % biggest protein is ca. 36 kDa so 1 mM = 15 mg
        amountProtein = 0.5*proteinConc*proteinMass;
        if amountProtein > 20 + easyMode*20
            disp("")
            printf("Ah, too bad! You don't have %.1f milligram of protein in the fridge\n", amountProtein)
            printf("You also do not want to spend even more time in the wetlab.\n")
            junk=input("<>","s");
            disp("A typical NMR sample has a volume of 500 microliter, so for a 10 kDa protein")
            disp("you need 5 mg of purified protein to get a 1 millimolar (mM) solution.")
            disp("Remember that this is an isotope labeled protein produced in minimal media,")
            disp("so reduce your protein concentration to use less than 20 mg.")
            
            disp("")
            continueQuestion = "y";
        end
        if (proteinConc < 0.010 && continueQuestion == "n")
            disp("")
            printf("NMR does not work on homeopathic dilutions...\n")
            printf("Increase your protein concentration to more than 10 micromolar.\n")
            disp("")
            junk=input("<>","s");
            continueQuestion = "y";
        end
        if ligandClass == 2 % this protein assembly,not present in easyMode
            if ligandStock > 0.5 && continueQuestion == "n"
                disp("")
                printf("Crap, your assembly %s precipitated upon concentrating to %.1f mM...\n", ...
                    acronymLigand, ligandStock)
                printf("For such large systems it is unlikely to have more than 500 micromolar\n")
                printf("as maximum concentration before it will crap out.\n")
                disp("")
                junk=input("<>","s");
                continueQuestion = "y";
            end
        elseif ligandClass == 1 % doubled max to 15 mM for easyMode 2, 10 mM easyMode 1
            if ligandStock > 5 + 5*easyMode && continueQuestion == "n"
                disp("")
                printf("F! Your ligand protein crapped out the solution at %.1f mM...\n", ligandStock)
                printf("Limit your ligand protein concentration to %d mM to prevent aggregation.\n", 5 + easyMode*5)
                disp("")
                junk=input("<>","s");
                continueQuestion = "y";
            end
        else    % 20 mM should be enough also for easyMode, except for easyMode=2 then 40mM is allowed, easyMode=3 gives 60 mM
            if ligandStock > 20 + max((easyMode-1),0)*20 && continueQuestion == "n"
                disp("")
                printf("Shoot! Your compound won't dissolve at %.1f mM...\n", ligandStock)
                printf("Limit your ligand concentration to %d mM.\n", 20+max((easyMode-1),0)*20)
                disp("")
                junk=input("<>","s");
                continueQuestion = "y";
            end
                 % prevent usage of stock solution that are less twice the concentration of the protein
            if ligandStock < 2*proteinConc && continueQuestion == "n"
                disp("")
                disp("Oosh. You took a very low stock concentration of the ligand.")
                disp("That would mean you would have to huge volumes of ligand to saturate the protein")
                disp("causing strong dilution of your protein and thus loss of sensitivity.")
                disp("Use at least 3x the protein concentration as ligand stock solution concentration.")
                disp("")
                junk=input("<>","s");
                continueQuestion = "y";
            end
        end
        % highest conc of ligand should be 9*KD + P0 for 90% saturation
        % dilution of P should be no more than 70% here
        % so stock should be 1.3*(9*KD+P0)
        % could be that student is given low affinity interaction:
        % in easyMode could be KD is 3mM  so 9*3=27 mM *1.3 = 35 mM is impossible
        % have to limit low affinity binders for protein to 1 mM (1.3*9=12 so not too bad)
        %                                        compounds to 2 mM 
        % with easyMode is 2 this should never pop up; (it should be possible to make a perfect sample).
        % so assuming 1mM sample, 40mM stock, KD = 40/13 = 3 mM maximum.
        if ligandStock < 1.3*(9*affinityValue*1e3 + proteinConc) && showSaturationTip == 0
            disp("")
            disp("Just one thing:")
            disp("")
            disp("With these concentration you will have difficulty to fully saturate the protein,")
            disp("i.e. to get all protein molecules bound to a ligand.")
            disp("")
            disp("You will need to add a large volume of ligand to see significant binding,")
            disp("causing significant dilution of your protein, which further complicates saturation.")
            disp("")
            showSaturationTip = 1;
            % check if ligandStock less then maximum:
            if (ligandClass == 1 && ligandStock < 5 + 5*easyMode) || (ligandClass == 0 && ligandStock < 20+max((easyMode-1),0)*20)
                disp("You could increase the concentration of your ligand stock solution.")
                disp("This will help to reach a high ligand concentration to saturate the protein.")
                if ligandClass == 0
                    printf("The maximum ligand stock you can use is %d mM.\n", 20+max((easyMode-1),0)*20)
                else
                    printf("The maximum ligand stock you can use is %d mM.\n", 5 + 5*easyMode)
                end
                continueQuestion = 'y';
                disp("")
            end
            if proteinConc >= 0.1 && affinityValue < 2e-3
                % lower protein conc only useful for sub-millimolar 
                disp("You can decrease the concentration of your protein solution.")
                disp("This will help to get a high molar excess of protein.")
                disp("The minimum reasonable protein concentration is 0.1 mM.")
                continueQuestion = 'y';
                disp("")
            end
            % ask to update or continue
            disp("It would be best to update your concentrations before continuing.")
            disp("")
            if continueQuestion == 'y'
                cqInput = input("Do you want to update your concentrations before continuing? y/n: ","s");
                if cqInput != "n" && cqInput != "y"
                    cqInput = input("Please type y/n: do you want to update your concentrations before continuing?:","s");
                    if cqInput !="n" && cqInput != "y"
                        % no valid input, ask for new concentrations
                        continueQuestion = "y";
                    end
                end
                if cqInput == "y"
                    continueQuestion = "y";
                else
                    continueQuestion = "n";
                    disp("")
                    disp("OK, just work with the samples you have now.")
                    disp("Try to add enough ligand in your titration to get at least 80% of the protein bound to ligand.")
                    disp("")
                end
            else
                disp("")
                disp("OK, just work with the samples you have now.")
                disp("Try to add enough ligand in your titration to get at least 80% of the protein bound to ligand.")
                disp("")
            end
        elseif ligandStock < 1.3*(9*affinityValue*1e3 + proteinConc) && showSaturationTip == 1
            disp("")
            disp("OK, just work with the samples you have now.")
            disp("Try to add enough ligand in your titration to get at least 80% of the protein bound to ligand.")
            disp("")
        end
        disp("")
    end % check input
end % while

% initialise variables for simulation of free spectrum
titrationPoint = 1;     % initialise counter of titration steps
tp = titrationPoint;
initialVolume=500;
molEq =0;
lConc =0;                     
molEqReal = 0;
totalVolume = initialVolume;
totalVolumeReal = initialVolume;
proteinDilution = 1;
pConc = proteinDilution*proteinConc;
pConcReal = pConc;
pConcv(1) = pConc;
lConcv(1) = 0;
cConcv(1) = 0;
molEqv(1) = 0;
pbVectorActual = 0;     % to track the actual population bound w/ pipet error
allSpectra = [];        % reset container for all spectra when making new sample
calcEquilibriumConcSingleSite % initialize
buildExchangeMatrix     % initialize for first spectrum of free protein

% echo result back
%clc
disp("")
disp("OK, your sample is ready.")
disp("")
printf("You have a 500 microliter NMR sample of %s (%.1f kDa) at %.3f mM\n",...
         acronymProtein, proteinMass, proteinConc)
printf("You will use a stock solution of %s (%.1f kDa) at %.3f mM\n",...
         acronymLigand, ligandMass, ligandStock)
disp("")
junk=input("<>","s");
disp("")
disp("Walking to the NMR ....")
nu = time();
a=1;
while time() < nu + 1.5
    a=a+1;
end 
disp("Putting the sample in the magnet ....")
nu = time();
a=1;
while time() < nu + 1.5
    a=a+1;
end 
disp("Setting up the machine ....")
nu = time();
a=1;
while time() < nu + 1.5
    a=a+1;
end 
disp("Ready to proceed!")
disp("")
junk=input("<>","s");

% explain how to proceed
if sampleOuttro == 1 && easyMode <= 2
    disp("")
    disp("You now first need to calibrate the 1H 90 degree pulse for your sample.")
    disp("First load the parameters of the calibration experiment by typing:")
    disp("")
    if easyMode == 0
        disp("rpar(\"find90\")")
        disp("")
        disp("at the command prompt (with the quotes surrounding find90) and hit return.")
        disp("(If you get an error saying find90 is undefined, you forgot the quotes!)")
        disp("")
    else
        disp("rpar(\"popt\")")
        disp("")
        disp("at the command prompt (with the quotes surrounding popt) and hit return.")
        disp("(If you get an error saying popt is undefined, you forgot the quotes!)")
        disp("")
    end
elseif easyMode > 2
    p1 = trup;      % skip calibration and set p1 to actual pulse length
    disp("")
    disp("Next load the parameter of the 2D HSQC by typing:")
    disp("")
    disp("rpar(\"HSQC\")")
    disp("")
    disp("at the command prompt (with the quotes surrounding HSQC) and hit return.")
    disp("(If you get an error saying HSQC is undefined, you forgot the quotes!)")
    disp("")
    if questionAsked(2)==1
        % apparently remaking sample
        % make sure that HSQC can be replotted
        figure(2)
        hold off
    end
else
    % apparently we already made a sample before
    % check if pulse was already calibrated
    if p1 > 0.1
        %, so we also have a p1 established
        disp("")
        disp("Next record again the HSQC spectrum of the new sample by typing")
        disp("\"zg\" at the command prompt.")
        disp("")
        if questionAsked(2)==1
            % apparently remaking sample
            % make sure that HSQC can be replotted
            figure(2)
            hold off
        end
    else
        %, so we still have to determine p1 
        disp("")
        disp("You now first need to calibrate the 1H 90 degree pulse for your sample.")
        disp("First load the parameters of the calibration experiment by typing:")
        disp("")
        if easyMode == 0
            disp("rpar(\"find90\")")
            disp("")
            disp("at the command prompt (with the quotes surrounding find90) and hit return.")
            disp("(If you get an error saying find90 is undefined, you forgot the quotes!)")
            disp("")
        else
            disp("rpar(\"popt\")")
            disp("")
            disp("at the command prompt (with the quotes surrounding popt) and hit return.")
            disp("(If you get an error saying popt is undefined, you forgot the quotes!)")
            disp("")
        end
    end
end

% switch off outtro for next time
sampleOuttro = 0;

