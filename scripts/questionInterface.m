% questionInterface.m
% to make sure students perceive this explictly as a question
% ask question on interpretation when ready and only if not done before!
% set correct question number for binding interface = cspq+1
if easyMode == 1
    cspq = 8;
elseif easyMode == 2
    cspq = 5;
else
    cspq = 4;
end
if questionAsked(cspq) == 0
    disp("")
    % for safety add check here as well
    if titrationPoint <= 2
        % user first needs to do at least two additions
        disp("First add some more ligand by typing \"titrate\" at the command prompt.")
    elseif pb < 0.8 && beNice == 1
        disp("Try adding more ligand to your protein.")
        disp("It looks like you're not done yet.")
        if affinityValue*1e3 < proteinConc && molEq < 1.5
        % check whether plateau has been reached in particular for high affinity binders
            disp("")
            disp("Even though the affinity is rather high, and your protein is nearly completely bound to ligand,")
            disp("it is better to record an additional point to measure the binding plateau.")
            disp("Type \"report\" to see how far you are in the titration.")
            disp("Type \"titrate\" to add more ligand, increase to at least 1.5 equivalents of ligand.")
        end
    else
        disp("First complete the chemical shift perturbation analysis.")
        printf("Type \"question(%d)\" at the the command prompt.\n", cspq)
    end
    disp("")
else
    % ready to the binding interface
    disp("")
    disp("Examine the chemical shift perturbation plot in Figure 5.")
    disp("")
    printf("Which %d residues are likely in the binding interface?\n", numBig)
    disp("Enter their residue numbers (number only!) separated by spaces below.")
    disp("")
    resList1 = input("Interface peaks are: ","s");
    justNumbers = regexprep(resList1, '\D',"");
    if length(justNumbers) != numBig
        disp("Please enter a sequence of 3 residue numbers as digits, e.g. 4 5 6")
        disp("")
        resList1 = input("Interface residues are: ","s");
        justNumbers = regexprep(resList1, '\D',"");
        if length(justNumbers) == 0
            disp("I give up.... I will take residues 1, 2 and 3 as your answer.")
            disp("")
            resList1 = "1 2 3";
            justNumbers = regexprep(resList1, '\D',"");
            junk=input("<>","s");
            disp("")
        elseif length(justNumbers) != numBig
            disp("OK, I'll see what I can do...")
        end
    end
    resList2 = justNumbers(1:numBig); % a simple string of numbers (first three of input)
    % check result % also if free state has been mis-identified!
    simCSPH = dwHvppm;
    simCSPN = dwHvppm;
    simCSP  = sqrt(simCSPH.^2 + (simCSPN/5).^2);
    [ sss, iii ] = sort(simCSP);
    % sometimes a fourth residue is actually close, so include 9-3 = 6,7,8,9
    if sss(numPeaks-numBig+1) - sss(numPeaks-numBig) < 0.1
        truList = iii(numPeaks-numBig:numPeaks); 
    else
        truList = iii(numPeaks-numBig+1:numPeaks);
    end
    interfaceScore=1;
    numCorrect=0;
    disp("")
    disp("Checking your answer ....")
    for p = 1:numBig
        resPresent = find((truList - str2num(resList2(p)))==0);
        if isempty(resPresent)
            disp("")
            printf("Residue %s is not correct.\n", resList2(p));
            disp("Maybe something went wrong when picking this peak.")
        else
            interfaceScore = interfaceScore +3;
            numCorrect = numCorrect +1;
        end
    end
    disp("")
    printf("Alright, you identified %d out 3 residues correctly.\n", numCorrect);
    if questionAsked(cspq+1) == 0
        score = score + interfaceScore;
        printf("You get %d points and now have %d points in total.\n", interfaceScore, score);
        questionAsked(cspq+1)=1;
    end
    disp("")
    junk=input("<>","s");
    % cue student to do final analysis if indeed saturated/ or if done
    % that is per residue exchange regime and estimates
    disp("")
    disp("Now you're ready for the final steps of the analysis and last few questions.")
    disp("")
    if easyMode == 0
        disp("In the last step of the analysis you examine the echange regime for each peak.")
        disp("You are asked to classify for each of the shifting peaks whether it is in slow/intermediate/fast")
        disp("exchange in the 1H dimension.")
        disp("Use the command \"showSlices\" to extract 1D slices in the 1H dimension.")
        disp("Use these views to classify the exchange regime.")
        disp("When you're ready to do this analysis, type \"question(9)\".");
    else
        disp("Let's determine the binding affinity.")
        printf("Type \"question(%d)\" at the the command prompt.\n", cspq+2)
        %disp("Use the command \"getKD\" to extract a binding curve and dissociation constant.")
    end
    disp("")
end
