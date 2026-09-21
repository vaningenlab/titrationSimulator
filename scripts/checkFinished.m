% checkFinished.m

disp("")
% check whether done by checking whether all questions answered
if sum(questionAsked) < numQuestions && pb < 0.7
    disp("")
    disp("It seems you're a still in the midde of the titration experiment...")
    printf("Use the %s command to see how far you are.\n", dispCommand("report"))
    printf("Continue w/ %s until you reach ~80 percent bound protein.\n", dispCommand("titrate"))
    disp("The other question will come along the way")
elseif sum(questionAsked) < numQuestions && pb >= 0.7
    % not all questions answered, check which
    disp("Checking whether you're really done ...")
    for q=1:numQuestions
        if questionAsked(q) == 0
            printf("Ah, it seems you forgot to answer question %d!\n", q)
        end
    end
    printf("Type %s at the prompt to still answer it,\n", dispCommand("question(x)"))
    disp("with x being the number of the question!")
    disp("")
    printf("After answering the question type %s\n", dispCommand("checkFinished"))
    disp("")
else
    % all question answered
    disp("")
    finalScore = 10*score/(10*numQuestions+10);
    printf("%s", YEL)
    printf("\t+++++++++++++++++++++++++++++++++++++++++++++++\n")
    printf("\t++                                           ++\n")
    printf("\t++     This is the end of the practical.     ++\n")
    printf("\t++                                           ++\n")
    printf("\t++     You have a final score of %3.1f/10      ++\n", finalScore)
    printf("\t++     You got %3d points out of %3d         ++\n", score, numQuestions*10+10)
    printf("\t++                                           ++\n")
    printf("\t+++++++++++++++++++++++++++++++++++++++++++++++\n")
    printf("%s", WHT)
    disp("")
    if finalScore > 8
        printf("Awesome %s%s%s, you did a really great job.\n", CYN,yourName, WHT)
    elseif finalScore > 6
        printf("Good job %s%s%s! You made it to the end and passed it!\n",CYN,yourName, WHT)
    else
        printf("Alright %s%s%s, you made it to the end...\n", CYN,yourName, WHT)
    end
    disp("You have seen how changes in peak positions can be used to determine")
    disp("the binding interface and binding affinity in protein-ligand interactions.")
    disp("")
    disp("One more thing:")
    disp("")
    showBreak
    %clc
    disp("")
    disp("You now need to hand in 3 things:")
    disp("- a plot of all spectra nicely on top of each other")
    disp("- a plot of your binding curve")
    disp("- a text file describing your system")
    disp("")
    showBreak
    disp("")
    disp("The program can make these files automatically for you. Just do:")
    printf("1. %s, to make sure the whole spectrum is shown.\n", dispCommand("zoomFull"))
    printf("2. %s, to make sure all spectra and peak labels are visible\n", dispCommand("plotAll"))
    disp("\t(you can then zoom in the plot manually a bit more if you wish)")
    printf("3. %s to save your results and the 3 files needed\n", dispCommand("saveResults"))
    disp("\t(please do not use the save option from the figure window)")
    disp("4. Send the 3 files created to your instructor.")
    disp("")
end
