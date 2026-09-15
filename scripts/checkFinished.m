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
    printf("+++++++++++++++++++++++++++++++++++++++++++++++\n")
    printf("++                                           ++\n")
    printf("++     This is the end of the practical.     ++\n")
    printf("++                                           ++\n")
    printf("++     You have a final score of %3.1f/10     ++\n", finalScore)
    printf("++     You got %3d points out of %3d         ++\n", score, numQuestions*10+10)
    printf("++                                           ++\n")
    printf("+++++++++++++++++++++++++++++++++++++++++++++++\n")
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
    disp("Hope you enjoyed it!")
    disp("")
    disp("One more thing:")
    disp("")
    showBreak
    %clc
    disp("")
    printf("- make sure the whole spectrum is shown (do %s if necessary).\n", dispCommand("zoomFull"))
    printf("- make sure all spectra and peak labels are visible (do %s if necessary)\n", dispCommand("plotAll"))
    printf("- then save your results with the %s command.\n", dispCommand("saveResults"))
    disp("  (please do not use the save option from the figure window)")
    disp("")
    printf("The \"saveResults\" command will put two figures and a text file in your working directory.\n", dispCommand("saveResults"))
    disp("Send these to your instructor.")
   
    if sendEmail == 1
        disp("Send these files to:")
        disp("")
        printf("        %s\n", instructorMail)
    else
        disp("Upload these files in the assignment in the electronic learning environment")
        disp("as indicated by your instructor")
     end
    disp("")
    printf("Once you have sent the files you can close this program by typing %s\n", dispCommand("goodbye"))
    disp("")
end
