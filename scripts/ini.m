% ini.m

% initialization script for NMR titration simulator

% NOTES TO INSTRUCTOR:
% ===> adapt the following 2 variables:
%           - instructorMail    : set to your email address, students will send their output to you.
%           - easyMode          : set to either 0, 1 or 2 or 3
%                                 this determines the difficulty level and time need for this practical
%                                 0 is not recommended
%                                 1 is easy + 1H pulse calibration + questions on 2D
%                                 2 is easy + 1H pulse calibration
%                                 3 is super easy w/o pulse calibration
% ===> depending on the chosen easyMode check the associated question.X.m file:
%           e.g. if easyMode = 1, question.1.m 
%                if easyMode = 2  question.2.m 
%                if easyMode = 3, question.3.m 
%                if easyMode = 0, question.0.m 
%           these question file can of course be altered to adjust the phrasing to your lectures.


clear -all

global swH swN wHv wNv dwHv dwNv titrationPoint allSpectra asHppm asNppm
global numLvls cntFactor baseLevel expPars plotSpectra cntLvls
global acronymProtein acronymLigand proteinMass ligandMass affinityRange
global gH gN B0 asH asN swH swN p1 beNice noiseX ns McX finalScore
global peakStoreX peakStoreY zfH zfN koff questionPoints questionAsked
global score S2Values plotPoints numPeaks yourName trup easyMode cq numPeaks
global pConcv lConcv cConcv molEqv CSP_o CSP_s CSP_f labelShift labelSize peakIntProfile
global wHvppm wNvppm centerHppm centerNppm ligandDescriptor numQuestions dwHvppm dwNvppm
global instructorMail noiseLevel my_pi numCalibCheck numCalib atH atN aa_string my_pi offResonance laN_Av laN_Bv

% reset octave prompt
PS1(":)] ");

% switch pager off to have output written to screen immediately
more off;

% record all typed in input/commands in log file
diary nmrsim.log

% set default fonts for plots
% for mac does not seem to be necessary
% for windows could be use ispc fucntion to check whether is windows
%set (0, "defaultaxesfontname", "Helvetica");
%set (0, "defaultaxesfontsize", 12);
%set (0, "defaulttextfontname", "Helvetica");
%set (0, "defaulttextfontsize", 14);

% first some important and adjustable variables
instructorMail = "h.vaningen@uu.nl";    % email where to send output
easyMode       = 1;                     % [0 | 1 | 2 | 3] 
                                        % 1 = easy = only use intermediate and fast exchange and no big protein assemblies
                                        %     this option is best for students in NMR courses
                                        % 2 = super easy = with 1H pulse calibration, no acq. times, fewer questions, only fast exchange
                                        %      only few KD/koff combinations that should always give a perfect result
                                        %      also more coaching to choose NMR sample concentrations
                                        %      best for students in courses where NMR theory is not the focus
                                        % 3 = super easy = no pulse calibration, no acq. times, fewer questions, only fast exchange
                                        %      only few KD/koff combinations that should always give a perfect result
                                        %      also more coaching to choose NMR sample concentrations
                                        %      best for students in courses where NMR theory is not the focus
                                        % 0 = original = could generate systems that does not result in saturated complex, could be slow exchange
                                        %      not recommended as it requires high frustration tolerance of students

% settings below generally do not need to be changed
beNice         = 1;                     % [0 | 1] prevent some mistakes yes (1) or no (0) (independent of easyMode)
                                        % recommended to keep at 1
numPeaks       = 9;                     % number of peaks to simulate (9 is fast enough)
                                        % more than 9 is not recommended as it has not been tested

if easyMode == 0
    if ispc()
        % windows version is starting from scripts dir
        copyfile("question.0.m", "question.m");
    else
        % mac/linux version is starting from main dir
        copyfile("scripts/question.0.m", "scripts/question.m");
    end
    numQuestions   = 13;                % total number of questions
    offResonance   = 0;                 % [0|1] include off-resonance effects yes or no DOES NOT WORK YET AS INTENDED
elseif easyMode  == 1
    if ispc()
        copyfile("question.1.m", "question.m");
    else
        copyfile("scripts/question.1.m", "scripts/question.m");
    end
    numQuestions   = 12;                % easy mode 1 has 12 questions + calibration points
    offResonance   = 0;                 % [0|1] include off-resonance effects yes or no
elseif easyMode  == 2
    if ispc()
        copyfile("question.2.m", "question.m");
    else
        copyfile("scripts/question.2.m", "scripts/question.m");
    end
    numQuestions   = 8;                 % super easy mode 2 has fewer questions to get faster to the titration
    offResonance   = 0;                 % [0|1] include off-resonance effects yes or no
else
    if ispc()
        copyfile("question.2.m", "question.m");
    else
        copyfile("scripts/question.2.m", "scripts/question.m");
    end
    numQuestions   = 7;                 % super easy mode 3 has even fewer questions to get faster to the titration
    offResonance   = 0;                 % [0|1] include off-resonance effects yes or no
end

% print info 

clc
disp("")
disp("\t****************************************")
disp("\t***                                  ***")
disp("\t***       titrationSimulator         ***")
disp("\t***                                  ***")
disp("\t****************************************")
disp("\t***      powered by GNU Octave       ***")
disp("\t****************************************")
disp("")
disp("\t++++++++++++++++++++++++++++++++++++++++")
disp("\t++         DO THE PEAKS MOVE?         ++")
disp("\t++++++++++++++++++++++++++++++++++++++++")
disp("\t++ (c)2024     HvI Utrecht University ++")
disp("\t++++++++++++++++++++++++++++++++++++++++")
disp("")

% These steps are run by the user by issuing commands at the prompt
% Just start the first step here.
% Every script ends with instructions to start new step

% define basic parameters
B0 = 14.0921;          % static magnetic field corresponding to 600 MHz [T]
gH = 2.6752e8;         % 1H gyromagnetic ratio [ T-1 s-1]
gN = -2.7120e7;        % 15N gyromagnetic ratio [ T-1 s-1]
my_pi = 3.14159265;    % custom pi to avoid overwriting value of pi by mistyping p1

% 1. based on user input generate protein/ligand system
if exist("state.out") == 2
    % user can also issue saveAll command to save full state including spectra and titration so as to restart and append to previous results
    % load all these data
    disp("")
    disp("Loading previous titration data (this may take a moment) ...")
    load("state.out")
    disp("Done!")
    disp("")
    disp("Type \"plotAll\" to plot all previous titration spectra.")
    disp("Type \"report\" for the details on the titration steps.")
    disp("Type \"listCommands\" for a list of all available commands.")
    disp("If you got stuck during the \"calcCSP\" or \"getKD\" analysis you can now restart these commands.")
    disp("")
else
    if exist("system.out") == 2
        disp("")
        disp("Loading previous titration system...")
        % load system from previous titration to allow restart
        load("system.out")
        disp("Done!")
    else
        % print welcome message
        disp("")
        disp("Welcome to the NMR titration simulator.")
        disp("")
        disp("Whenever you see this symbol: <> press return/enter to continue!")
        if ispc()
            disp("For windows users: you sometimes need to press twice ...")
        end
        disp("")
        disp("Whenever you see this symbol: :)] you have to enter a command.")
        disp("Which command will be clear later on.")
        disp("")
        disp("Good luck!")
        disp("")
        junk=input("<>","s");
        clc

        disp("\t**** NMR titration simulator ****")
        disp("")
        disp("You're about to do an in silico NMR titration experiment")
        disp("to investigate a protein-ligand interaction.")
        disp("")
        disp("You will get your own protein and your own ligand to investigate.")
        disp("The ligand is either a small molecule, a peptide or another protein.")
        disp("")
        disp("Your goal is to determine the binding interface")
        if easyMode >=1
            disp("and the dissociation constant.")
        end
        disp("")
        disp("This simulator mimics the important steps")
        disp("in sample preparation and data acquisition.")
        disp("")
        disp("You will be guided step-by-step through the experiment.")
        disp("If something is unclear, ask your instructor.")
        disp("")
        printf("There are %d multiple choice questions along the way.\n", numQuestions)
        disp("These will be automatically evaluated and scored.")
        disp("")
        junk=input("<>","s");
        clc
        disp("")
        disp("OK, time to start. Enjoy!")
        disp("")
        junk=input("<>","s");

        initialiseSystem
        initialiseSpectrum

        % define unique pulse lengths that will be fixed, also when restarting
        trup = 7 + 5*rand();    % uniform ditribution so that higher values are equally likely

        % automatically write values to file to allow restart of titration
        % add debug info
        pcOctvers = version;
        pcUname   = uname();
        pcToolkit = graphics_toolkit;
        save("system.out","acronymProtein", "acronymLigand", "proteinDescriptor", "ligandDescriptor", ...
                    "proteinMass", "ligandMass", "affinityValue", "ligandClass", "trup", ...
                    "koff", "affinityRange", "yourName", "dwHv", "dwNv", "wHv", "wNv", "swN", "swH", ...
                    "wHvppm", "wNvppm", "dwHvppm", "dwNvppm", "swHppm", "swNppm", "centerHppm", "centerNppm",...
                    "numSmall", "numZero", "numMed", "numBig", "aa_string", "overlap", ...
                    "pcToolkit", "pcUname", "pcOctvers");
    end
    % load H2O pulse calibration parameters
    prepareH2O;                 % define offset, spectrum, relaxation etc.
    setupH2O;                   % define matrices and propagators for one spin system

    % load HSQC parameters
    calcRelaxationRates         % use system info to calculate all relaxation rates
    setupAX                     % time to define spin matrices and derive Liouvillian

    % define some more variables
    expPars = "None";       % parameters set for NMR experiment
    number  = 0;            % question number identifier
    numLvls   = 10;         % initial settings for contourplot
    cntFactor = 1.4;        % initial settings for contourplot
    startFloor= 0.05;        % initial settings for contourplot
    maxSpectra= 15;         % maximum amount of overlaid spectra before reduceOverlay works
    labelShift= 35;         % shift of peak labels from peak center in Hz
    labelSize = 12;         % font size for peak labels

    p1  = 0.1;              % initial value of p1
    p21 = 30.5;             % 15N 90 degree pulse, not changed here
    JNH = -92;              % 1JHN
    tau = abs(1/(4*JNH));   % tau of INEPT, can be modified by user (only easyMode = 0)
    trutau = tau;           % for easy resetting: tau=trutau
    tG  = 0.002;            % gradient time, NOT USED YET
    Gz  = 0.6;              % T/m => *100= G/cm, NOT USED YET

    score          = 0;                     % initialize score of student
    questionPoints = 10;                    % number of points per correct answer
    questionAsked  = zeros(1,numQuestions); % to keep track whether question has been asked
    calcCSPintro   = 1;                     % do calcCSP intro
    cspTime        = 0;                     % to keep track of number of times analysis was done
    sampleOuttro   = 1;                     % do makeSample outtro to connect to pulse calibartion
    getkdTime      = 0;                     % to keep track of number of times analysis was done
    fidShown       = 0;                     % to skip showFID instruction after first time
    plotPoints     = 0;                     % to keep track of how many spectra are plotted
    titrationPoints= 0;                     % to keep of number of titration steps
    numCalibCheck  = 0;                     % to keep track of number of times calibration check was done
    numCalib       = 0;                     % to keep track of number of times calibration was done
    showHint       = 0;                     % to track if overlap hint was shown
    pbVectorActual = [];                    % to track the actual population bound w/ pipet error
    disp("")
    disp("Type \"makeSample\" (without the quotes) at the command prompt to continue.")
    disp("")

end % all startup options


