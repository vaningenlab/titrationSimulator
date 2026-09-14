% saveState.m

disp("")
disp("Saving the titration into \"state.out\" ...")
% remove audioplayer objects before saving 
clear player
save "state.out"
disp("Done!")
printf("You can now quit the program with %s and restart later.\n", dispCommand("exit"))
disp("")
