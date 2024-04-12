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
disp("***      2. Your NMR sample      ***")
disp("")

if questionAsked(1)==0
    printf("OK, now you need to prepare an NMR sample of your protein %s (%.1f kDa),\n", acronymProtein, proteinMass)
    printf("and a stock solution of your ligand %s (%.1f kDa).\n", acronymLigand, ligandMass)
    printf("The goal is to follow the peaks of the protein upon titrating in the ligand.\n")
    disp("")
    junk=input("<>","s");
    question(1)
    junk=input("<>","s");
    disp("")
    disp("NEXT:")
    disp("Now you need to define the protein concentration of your sample.")
    if easyMode >= 2
        disp("This is typically 0.5 to 1 mM.")
    elseif easyMode == 1
        disp("This is typically 0.1 to 1 mM.")
    else
        disp("This is usually somewhere between tens of micromolar (uM) and few millimolar (mM).")
    end
    disp("")
    disp("Also, you need to define the concentration of your ligand stock solution.")
    disp("Since you add the ligand in steps to your NMR sample, ")
    disp("this stock solution should be as concentrated as possible to reduce dilution effects.")
    if easyMode >= 2
        if ligandClass == 0
            disp("For small molecule compounds, this is typically 10 times")
            disp("the expected dissocation constant (KD), so somewhere between 10 and 40 mM.")
        else
            disp("For protein ligands, this is typically limited by their solubility,")
            disp("so somewhere between 5 and 15 mM.")
        end
    elseif easyMode == 1
        if ligandClass == 0
            disp("For small molecule compounds, this is typically 10-20 times")
            disp("the expected dissocation constant (KD), so somewhere between 10 and 40 mM.")
        else
            disp("For protein ligands, this is typically limited by their solubility,")
            disp("luckily yours can be concentrated to 10 mM.")
        end
    end
    disp("")
    junk=input("<>","s");
    disp("")
    disp("Next enter your protein and ligand concentration in units of mM.")
    disp("")
end

continueQuestion = "y";
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
        if ligandStock < 1.3*(9*affinityValue*1e3 + proteinConc) && continueQuestion == "n"
            disp("")
            disp("Just one thing:")
            disp("With these concentration you will have difficulty to fully saturate the protein.")
            disp("This means you will need to add a large volume of ligand to see significant binding,")
            disp("causing significant dilution of your protein, which further complicates saturation.")
            disp("")
            disp("Increase the concentration of your ligand stock solution if possible.")
            disp("Or lower your protein concentration (especially when you have micromolar KD).")
            disp("")
            if easyMode != 0
                disp("The minimum reasonable protein concentration is 0.1 mM.")
                if ligandClass == 0
                    printf("The maximum ligand stock you can use is %d mM.\n", 20+max((easyMode-1),0)*20)
                else
                    printf("The maximum ligand stock you can use is %d mM.\n", 5 + 5*easyMode)
                end
            end
            disp("")
            junk=input("<>","s");
            disp("")
            continueInvQuestion = input("Do you want to continue WITHOUT updating your concentrations? y/n: ","s");
            if continueInvQuestion != "n" && continueInvQuestion != "y"
                continueInvQuestion = input("Please type y/n: do you want to continue WITHOUT updating your concentrations?:","s");
                if continueInvQuestion !="n" && continueInvQuestion != "y"
                    continueInvQuestion = "y";
                end
            end
            if continueInvQuestion == "n"
                continueQuestion = "y";
            end
        end
        disp("")
    end % check input
end % while

% initialise variables for simulation of free spectrum
titrationPoint = 1;     % initialise counter of titration steps
tp = titrationPoint;
initialVolume=500;
molEq =0;
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
allSpectra = [];        % reset container for all spectra when making new sample

% echo result back
clc
disp("")
disp("OK, your sample is ready.")
disp("")
printf("You have a 500 microliter NMR sample of %s (%.1f kDa) at %.3f mM\n",...
         acronymProtein, proteinMass, proteinConc)
printf("You will use a stock solution of %s (%.1f kDa) at %.3f mM\n",...
         acronymLigand, ligandMass, ligandStock)
disp("")
disp("Walking to the NMR ....")
nu = time();
a=1;
while time() < nu + 2
    a=a+1;
end 
disp("Putting the sample in the magnet ....")
nu = time();
a=1;
while time() < nu + 2
    a=a+1;
end 
disp("Setting up some stuff ....")
nu = time();
a=1;
while time() < nu + 2
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

