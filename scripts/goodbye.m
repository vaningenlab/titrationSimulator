% goodbye.m
% custum exit script

% check whether all questions were asked

if sum(questionAsked) < numQuestions
	disp("")
	disp("Hmmm. It seems you didn't answer all the questions yet.")
	disp("Let me have a look....")
	nu = time();
	a=1;
	while time() < nu + 1
		a=a+1;
	end
	printf("You missed question ")
	for q=1:numQuestions
		if questionAsked(q) == 0
			printf("%d ",q)
		end
	end
	printf("\n")
	disp("")
	disp("Go ask your instructor for advice")
	disp("")
else
	% apparently all questions were asked
	disp("")
	disp("Just double checking:")
	disp("Did you send/upload the figures of your all titration spectra and the binding curve")
	disp("and the system details file?")
	disp("")
	showBreak
	disp("")
	printf("If you you did, perfect and you can type %s to close the program.\n", dispCommand("byebye"))
	disp("")
	printf("If not, make sure the whole spectrum is shown (do %s if necessary).\n", dispCommand("zoomFull"))
	printf("Then make sure all spectra and peak labels are visible (do %s if necessary).\n", dispCommand("plotAll"))
	printf("Then generate the final output files using the %s command.\n", dispCommand("saveResults"))
	disp("It will put three files in your working directory.")
	disp("")
	if sendEmail == 1
		disp("Send these files")
		printf("to: %s\n", instructorMail)
	else
		disp("Upload these files in the assignment in the electronic learning environment")
		disp("as indicated by your instructor")
	end
	disp("")
	% save everything for debugging when students have weird results
	disp("Saving the titration into \"state.out\" ...")
	% remove audioplayer objects before saving 
	clear player
	save "state.out"
	disp("Done!")
	disp("")
	printf("Once you have sent the files you can close this program by typing %s\n", dispCommand("byebye"))
	disp("")
end
