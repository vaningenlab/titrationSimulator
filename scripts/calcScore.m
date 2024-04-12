% calcScore.m

function newScore = calcScore(answer, oldScore, correctAnswer, questionPoints);
    
    global cq
    
    %pause (0.5) % somehow cause huge delay with 1 sec
    
    pp = mod(round(3*rand()),3);
    if answer == correctAnswer
        newScore = oldScore + questionPoints;
        disp("")
        if pp == 0
            printf("Good job. You now have %d points.\n", newScore);
        elseif pp == 1
            printf("Yes. New score is %d points.\n", newScore);
        else
            printf("Alright! Another %d gets you %d points...\n", questionPoints, newScore);
        end
        disp("")
    else
        newScore = oldScore;
        disp("")
        if pp == 0
            answerTwo = input("Ah too bad...Second guess?? ","s");
            answerTwo = checkAnswer(answerTwo);
        elseif pp == 1
            answerTwo = input("No, that's is not right...reconsider? ","s");
            answerTwo = checkAnswer(answerTwo);
        else
            answerTwo = input("No unfortunately...give it another thought... ","s");
            answerTwo = checkAnswer(answerTwo);
        end
        % take first word from input
        answerTwo = strsplit(strtrim(answerTwo), " ");
        % remove any non-letter/digit symbols
        answerTwo = regexprep(answerTwo{1}, '\W',"");
        % convert to uppercase
        answerTwo = toupper(answerTwo);
        if answerTwo == correctAnswer
            disp("Indeed!")
        else
            disp("Sorry that's still not correct...")
        end
        disp("");
    end
    cq = cq+1;  % increment the current question index
    
endfunction
