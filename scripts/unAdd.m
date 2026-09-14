% unAdd.m
% 
% remove the last addition in case of typo for instance

% execute after titrate.m step; before recording new spectrum

% parameters that need updating
%   tp  - titration point index
%   parameters of current sample:
%       - totalVolume / totalVolumeReal
%       - pConc / pConcReal
%       - lConc / lConcReal
%       - molEq / molEqReal
%   vectors storing titration series:
%       - pConcv
%       - lConcv
%       - molEqv
%       - pbVectorActual (zg)
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
    % reset the vectors
    pConcv = pConcv(1:tp);
    lConcv = lConcv(1:tp);
    molEqv = molEqv(1:tp);
    cConcv = cConcv(1:tp);
    pbVectorActual = pbVectorActual(1:tp);
    % reset the intended values (w/o pipetting errors)
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
        showBreak
        disp("")
    end
    totalVolume = totalVolume - volAdd;
    % reset the actual values (w/ pipetting errors)
    totalVolumeReal = totalVolumeReal - volAddReal;
    molEqReal  = molEqReal - molAddReal;
    proteinDilutionReal = initialVolume/totalVolumeReal;
    pConcReal = proteinDilutionReal*proteinConc;
    lConcReal = ligandStock*(totalVolumeReal-initialVolume)/totalVolumeReal;
    disp("The addition has been undone.")
    printf("Double check by issuing %s.\n", dispCommand("report"));
    printf("Then redo your addition by typing %s at the command prompt.\n", dispCommand("titrate"))
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
    printf("you will have to restart from scratch and make a new sample by typing %s at the prompt.\n", dispCommand("makeSample"))
    printf("Otherwise, just continue the titration by typing %s.\n", dispCommand("titrate"))
    disp("")
end
