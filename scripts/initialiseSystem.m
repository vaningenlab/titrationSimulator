% initialiseSystem.m
%
% sets: - acronymProtein / acronymLigand
%       - proteinMass / ligandMass
%       - proteinDescriptor / ligandDescriptor
%       - affinityValue
% and writes these values to a file 'system.out'


% echo to student

%disp("\t**** NMR titration simulator ****")
clc
disp("")
disp("***      1. Your protein and ligand       ***")
disp("")
disp("The program will now ask you a few simple questions")
disp("in order to select a system for you.")
disp("Don't worry about typos or mistakes, it should work anyways.")
disp("")
junk=input("<>","s");
disp("")

tmp = rand();   % start with first rand to make sure next one is really different
                % this is paranoia

% generate acronym of protein
yourName = input("What is your first name? ", "s");
acronymProtein = createAcronym(yourName);
if acronymProtein == 0
    disp("Try again. Maybe add your last name as well.")
    yourName = input("Please enter your name : ","s");
    acronymProtein = createAcronym(yourName);
    if acronymProtein == 0
        disp("OK, I'll guess ...");
        junk=input("<>","s");
        disp("Your name is ... Anita!");
        acronymProtein = "ANITA";
    end
end
disp("")

% generate acronym of ligand
food = input("What is your favorite food? ", "s");
acronymLigand = createAcronym(food);
if acronymLigand == 0
    food = input("Try again. Please enter your favorite food : ","s");
    acronymLigand = createAcronym(food);
    if acronymLigand == 0
        disp("OK, I'll guess ...");
        junk=input("<>","s");
        disp("Your favorite food is snails!")
        acronymLigand = "SNAILS";
    end
end
disp("")

% generate vector of numbers from birthday
birthday = input("Please enter your birthday (dd/mm/yyyy): ", "s");
[vectorOfNumbers, arrayOfNumbers]  = extractNumbers(birthday);
if vectorOfNumbers == 0
    birthDay = input("Try again. Please enter your birtday : ","s");
    [vectorOfNumbers arrayOfNumbers ] = extractNumbers(birthDay);
    if vectorOfNumbers == 0
        disp("Ok, I'll guess...")
        junk=input("<>","s");
        disp("Your birthday is Nov 30th 1976!")
        vectorOfNumbers = [ 3 0 1 1 1 9 7 6];
        arrayOfNumbers = {"3", "0", "1", "1", "1", "9", "7", "6"};
    end
end
disp("")

% generate amino acid sequence
long_aa_string = input("Please enter an inspiring sentence: ", "s");
[aa_length, aa_string]  = extractAA(long_aa_string);
if aa_length == 0
    long_aa_string = input("Try again. Please enter a sentence with regular letters: ","s");
    [aa_length, aa_string]  = extractAA(long_aa_string);
    if aa_length == 0
        disp("Ok, I'll guess...")
        junk=input("<>","s");
        disp("")
        disp("You may find this inspiring:")
        disp("  In theory there is no difference between theory and practice,")
        disp("  in practice, this is only true for NMR.")
        disp("")
        junk=input("<>","s");
        aa_string = "AVDKFGNSCEFHILMQRTWY"(1:numPeaks);
    end
end
disp("")

% echo to student
disp("The computer is now processing your input ")
disp("to derive the system of your study....")
nu = time();
while time() < nu + 2
    a = 1+1;
end

% patch protein and ligand name
acronymProtein = strcat(acronymProtein, arrayOfNumbers{2});
lastNum        = abs(vectorOfNumbers(2)-vectorOfNumbers(length(vectorOfNumbers)));
acronymLigand  = strcat(acronymLigand, arrayOfNumbers{max(size(arrayOfNumbers))}, int2str(lastNum));

% generate molecular massess, should be 8-30 kDa
% based on birthday sum of numbers; can vary between 4 and 48
% sum*0.5 -5 + 10*rand() for minimum of 26
% sum -5 + 10*rand() for 13-25
% (sum+3)*2 -4 + 8*rand() for 4-13

if sum(vectorOfNumbers) >= 26
    proteinMass = sum(vectorOfNumbers)*0.5 - 5 + 10*rand();            % maximum is 48*0.5 + 5 = 29 kDa
                                                                       % minimum is 26*0.5 - 5 =  8 kDa
elseif sum(vectorOfNumbers) >= 13 && sum(vectorOfNumbers) < 26
    proteinMass = sum(vectorOfNumbers) - 4 - 5 + 10*rand();            % maximum is 25 + 5 = 30 kDa
                                                                       % minimum is 13 - 5 = 8 kDa
elseif sum(vectorOfNumbers) < 13
    proteinMass = (sum(vectorOfNumbers)+2)*2  - 4 + 8*rand();         % maximum is (12+2)*2 + 4 = 32 kDa
                                                                       % minimum is (4+2)*2 - 4 = 8 kDa
end 

% really make sure no funny stuff and cap at 30 kDa
if proteinMass < 8
    proteinMass = 15 -5 + 10*rand();
end
if proteinMass > 30
    proteinMass = 30 -5 + 5*rand();
end

% define ligand classes and exchange classes
% ligand:                                               easymode
% class 0: only small molecule or peptide ligands       0,1,2,3
% class 1: protein ligands                              0,1,2,3
% class 2: big protein assemblies                       0
% exchange:
% class 0: fast exchange                                0,1,2,3
% class 1: fast-to-intermediate exchange                0,1,2,3
% class 2: intermediate exchange                        0,1
% class 3: slow-to-intermediate exchange                0
% class 4: slow exchange                                0

if easyMode == 3
    ligandClass = 0 ;
    exchangeClass = mod(round(2*rand()),2);
elseif easyMode == 2
    ligandClass = mod(round(2*rand()),2);
    exchangeClass = mod(round(2*rand()),2);
elseif easyMode == 1
    ligandClass = mod(round(2*rand()),2);
    exchangeClass =  mod(round(4*rand()),3);
else
    ligandClass = mod(round(3*rand()),3);
    exchangeClass =  mod(round(4*rand()),5);
end 

% define mass
if ligandClass == 0
    % class 0: only small molecule or peptide ligands
    ligandType = mod(round(2*rand()),2);
    if ligandType == 0
        ligandMass       = 0.25 + 0.5*rand();   % 0.25 - 0.75 kDa
        ligandDescriptor = "compound";
    else
        ligandMass       = 1 + 4*rand();        % 1 - 5 kDa
        ligandDescriptor = "peptide";
    end
elseif ligandClass == 1
    % class 1: protein ligands
    ligandDescriptor  = "protein";
    if easyMode < 1
        ligandMass = 5 + 9*rand();            % reduced to 5-15 kDa so that maximum complex size is 30 + 15 = 45 kDa is just doable?
    else
        ligandMass = 5 + 5*rand();            % reduced to 5-10 kDa for easyMode=1/2/3, depending on proteinMass so that total mass never more than kDa
        if ligandMass + proteinMass > 35
            ligandMass = 35 - proteinMass;
        end
    end
else
    % class 3: protein assembly, only easyMode = 0
    ligandMass = 100 - 25 + 100*rand();
    ligandDescriptor = "protein assembly";
end 

% define kon/koff
% make sure to get mixture of slow-intermediate, intermediate, fast-intermediate and fast exchange
% max dw 1H is 0.4 ppm, max dw 15N is 2.4 ppm, is 1500 s-1 / 1000 s-1
% class 0: fast exchange                    : kex = dw*2  = 3000 => koff = 3000 => 3000 - 10000
% class 1: fast-to-intermediate exchange    : kex = dw    = 1500 => koff =  750 =>  600 –  1000
% class 2: intermediate exchange            : kex = dw/2  =  750 => koff =  325 =>  250 -   400
% class 3: slow-to-intermediate exchange    : kex = dw/4  =  325 => koff =  160 =>  100 -   200
% class 4: slow exchange                    : kex = dw/10 =   32 => koff =   30 =>   10 -    50
if exchangeClass == 0
    koff = 3000 + 7000*rand();
    onRate = 4e6; 
    % reduced from 1e8 to get lower affinities /higher KDs so that binding curves are better
    % this gives KD = koff/kon of 3000/4e6 = 750 uM to 10e3/4e6 = 2.5 mM
    % for saturation of protein it is required to add 10*KD +P0, so ligand stock should be double, 20*KD
    % so should max ligand stock at 20 mM, is OK in makeSample, set to 60 / 40 / 20 / 20 mM for easy mode 3/2/1/0 
elseif exchangeClass == 1
    koff = 600 + 400*rand();
    onRate = 4e6; 
    % this gives KD = koff/kon of 600/4e6 = 150 uM to 1e3/4e6 = 250 uM
elseif exchangeClass == 2
    koff = 250 + 150*rand();
    onRate = 4e6;
    % this gives KD = koff/kon of 250/4e6 = 62 uM to 400/4e6 = 100 uM
elseif exchangeClass ==3
    koff = 100 + 100*rand();
    onRate = 4e6;
    % this gives KD = koff/kon of 100/4e6 = 25 uM to 200/4e6 = 50 uM
else
    onRate = 1e6    % for proteins set to 1e6 Baker 2004
    koff = 10 + 40*rand();
    % this gives KD = koff/kon of 10/1e6 = 10 uM to 50/1e6 = 50 uM
end

affinityValue = koff/onRate;

if affinityValue < 1e-7
    affinityRange = "nanomolar";        % less than 0.1 uM
elseif affinityValue < 1e-4
    affinityRange = "low micromolar";   % less than 100 uM
elseif affinityValue < 1e-3
    affinityRange = "high micromolar";  % less than 1 mM
else
    affinityRange = "millimolar";
end

% list of quasi scientific words
proteinWords = {"auto-immune"; "transcription"; "translation"; "electron-transfer"; "GTPase"; "cytoskeleton"; "neuro-degenerative"; "chaperone"; "viral"; "angiogenesis"; "biosynthetic"};
proteinDescriptor = proteinWords{round((length(proteinWords)-1)*rand()+1)};

% echo back system
disp("")
disp("You will perform a titration of:")
disp("")
printf("\t%s factor %s ( %.1f kDa) with\n", proteinDescriptor, acronymProtein, proteinMass)
printf("\t%s %s ( %.1f kDa)\n", ligandDescriptor, acronymLigand, ligandMass)
disp("")
printf("The amino acid squence of %s is %s\n", acronymProtein, aa_string)
disp("")
junk=input("<>","s");
disp("")
printf("Preliminary experiments have shown that the\n")
printf("dissociation constant KD is in the %s range\n", affinityRange)
disp("")
disp("By doing an NMR titration experiment you will determine")
disp("the binding interface and the binding constant of this interaction.")
disp("")
disp("In other words, the question is: Do the peaks move?")
disp("")
junk=input("<>","s");