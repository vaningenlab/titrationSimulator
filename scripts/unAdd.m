% unAdd.m
% 
% remove the last addition in case of typo for instance

% execute after titrate.m step; before recording new spectrum

% parameters that need updating
%   tp  - titration point index
%   parameters of current sample:
%       - totalVolume
%       - pConc
%       - lConc
%       - molEq
%   vectors storing titration series:
%       - pConcv
%       - lConcv
%       - molEqv
% conditions to catch
%   - unAdd can only be done directly after titrate.m, before zg/xfb/process2D
%       thus titrationPoint has been incremented, but plotPoints has not!
% ! need to remove actual addition (i.e. w pipet error) not the intended addition!

if titrationPoint > plotPoints && titrationPoint > 1
    % go ahead and undo
    disp("")
    disp("You're so lucky you can undo this here.")
    disp("In a real experiment this obviously doesn't work...");
    disp("")
    titrationPoint = titrationPoint-1;
    tp = titrationPoint;
    pConcv = pConcv(1:tp);
    lConcv = lConcv(1:tp);
    molEqv = molEqv(1:tp);
    cConcv = cConcv(1:tp);
    pConc  = pConcv(tp);
    lConc  = lConcv(tp);
    molEq  = molEqv(tp);
    % also reset concentration of complex and reset volume!
    cConc  = cConcv(tp);
    if cConc == 0 && titrationPoint > 1
        disp("")
        disp("Hmm, wait a second, something is wrong here...")
        printf("[complex] is %.3f\n",cConcv(titrationPoint))
        printf("[ligand] is %.3f\n",lConcv(titrationPoint))
        disp("Go ask your instructor.")
        disp("")
        junk=input("<>","s");
        disp("")
    end
    totalVolume = totalVolume - volAdd;
    disp("The addition has been undone.")
    disp("Double check by issuing \"report\".");
    disp("Then redo your addition by typing \"titrate\" at the command prompt.")
    disp("")
else
    % sorry computer says no
    disp("")
    disp("Sorry, computer says no...");
    disp("")
    disp("You already recorded the spectrum after your addition.")
    disp("Now you cannot undo that anymore.")
    disp("")
    disp("If you really want to change the titration,")
    disp("you will have to start from scratch and make a new sample by typing \"makeSample\" at the prompt.")
    disp("Otherwise, just continue the titration by typing \"titrate\".")
    disp("")
end
