% playFID.m
% play FID as audiotrack

disp("")
disp("Cool... you found this command to listen to the FID...")
disp("")
showBreak
if exist("dim1FIDY")
	disp("")
	player = audioplayer(dim1FIDY,swH);
	play(player)
	printf("%s", YEL)
	typewriter("This is ... the sound from the nuclear spins ...", 0.2)
	printf("%s", WHT)
	disp("")
elseif exist("SrH2O")
	disp("")
	player = audioplayer(real(McH2O),swH2O);
	play(player)
	printf("%s", YEL)
	typewriter("Yes, that 's the sound from the nuclear spins in water ...", 0.05)
	printf("%s", WHT)
	disp("")
else
	disp("")
	disp("Sorry, nothing to play...")
end
disp("")