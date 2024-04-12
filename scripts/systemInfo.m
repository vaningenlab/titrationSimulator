% systemInfo.m

disp("")
printf("\t*** system details ***\n")
disp("")
printf("\tprotein                      : %s factor %s (%.1f kDa)\n", proteinDescriptor, acronymProtein, proteinMass)
printf("\tligand                       : %s %s (%.1f kDa)\n", ligandDescriptor, acronymLigand, ligandMass)
if affinityValue < 100e-9
    printf("\ttrue dissocation constant    : %.2f nM\n", affinityValue*1e9)
elseif affinityValue < 100e-6
    printf("\ttrue dissocation constant    : %.2f uM\n", affinityValue*1e6)
else
    printf("\ttrue dissocation constant    : %.2f mM\n", affinityValue*1e3)
end
if easyMode >=1 && exist("KD_fit", "var")
	if KD_fit > 1
	    printf("\tfitted dissocation constant  : %.2f mM\n", KD_fit)
	elseif KD_fit > 1e-3
	    printf("\tfitted dissocation constant  : %.0f uM\n", KD_fit*1e3)
	else
	    printf("\tfitted dissocation constant  : %.0f nM\n", KD_fit*1e6)
	end
	printf("\terror in dissocation constant: %.1f %%\n", (KD_fit-affinityValue*1e3)/(affinityValue*1e3)*100)
end
printf("\texchange class               : %d\n", exchangeClass)
printf("\toff-rate                     : %.2f s-1\n", koff)
printf("\ton-rate                      : %.2f 10^6 M-1 s-1\n", koff/affinityValue*1e-6)
if exist("proteinConc", "var")
	if proteinConc < 100e-6
    	printf("\tprotein concentration        : %.2f uM\n", proteinConc*1e3)
	else
    	printf("\tprotein concentration        : %.2f mM\n", proteinConc)
    end
    printf("\tligand stock                 : %.2f mM\n", ligandStock)
end
disp("")
if plotPoints > 0
	printf("\tcalibrated p1                 : %.2f us\n", p1)
	printf("\ttrue p1                       : %.2f us\n", trup)
	printf("\ttau INEPT                     : %.2f ms\n", tau*1e3)
	printf("\tacq. time 1H                  : %.3f s\n", atH)
	printf("\tacq. time 15N                 : %.3f s\n", atN)
	printf("\tns                            : %d\n", ns)
end
disp("")
report
disp("")
disp("\t*** score ***\n")
disp("")
if easyMode < 3
	printf("Your final score          : %d out of %d points\n", score, numQuestions*questionPoints+10)
else
	printf("Your final score          : %d out of %d points\n", score, numQuestions*questionPoints)
end
disp("")
disp("")
if sum(questionAsked) < numQuestions
	disp("You have not answered all questions, so either you're simply not done yet,")
	disp("or you missed a question")
	disp("")
	disp("You have not answered question(s):")
	for q=1:numQuestions
		if questionAsked(q) == 0
			printf(" %d ", q)
		end 
	end 
	disp("Type, for example, \"question(5)\" to still try to answer question 5.")
	disp("")
	disp("If you are not done yet w/ the titration, simply continue your experiment.")
	disp("You should encounter all questions along the way.")
	disp("")
else
	disp("Type \"goodbye\" to quit")
end
disp("")
