% bootNMR.m

% total 12 sec: 5 sec boot to magnet, 12 sec to insert

% start intro music
player = audioplayer(leadTrack, fs);
% t = 0  time start
play(player)

pause(0.3)
disp("")
disp("")
typewriter("ENERGIZING MAGNET",0.1)
% 17 chars = 1.7 sec
typewriter(" ...",0.5)
% 4 chars = 2 sec
disp("")
% t = 4 sec

p=1/21;  % to make sure appearance takes 1 sec = 0.5 bar

printf("%s", CYN)
disp("")
disp("\t                                      I      0            ")
pause(p)                            
disp("\t                                     III :: III           ")
pause(p)                            
disp("\t                                     III X$ III           ")
pause(p)                            
disp("\t                                   +oBoIIIIIIoBo+         ")
pause(p)                            
disp("\t                                 IIIIIIIIIIIIIIIIII       ")
pause(p)                            
disp("\t                                 IIIIIIIIIIIIIIIIII       ")
pause(p)                            
disp("\t                                 IIIIIIIIIIIIIIIIII       ")
pause(p)                            
disp("\t                                 IIIIIIIIIII. IIIII       ")
pause(p)                            
disp("\t                                 IIIIIII:  .IIIIIII       ")
pause(p)                            
disp("\t                             ....IIIIII      IIIIII....   ")
pause(p)                            
disp("\t                            @IIII@IIIIII   cIIIIII@IIII@  ")
pause(p)                            
disp("\t                            @IIII@IIIIIIIIIIIIIIII@IIII@  ")
pause(p)                            
disp("\t                            .wwwwoIIIIIIIIIIIIIIIIIwwww.  ")
pause(p)                            
disp("\t                             IIIIIIIIIIIIIIIIIIIIIIIIII   ")
pause(p)                            
disp("\t                             IIIIIIIIIIIIIIIIIIIIIIIIII   ")
pause(p)                            
disp("\t                             IIIIMMMMMMMMMMMMMMMMMMIIII   ")
pause(p)                            
disp("\t                             IIII                  IIII   ")
pause(p)                            
disp("\t                             IIII                  IIII   ")
pause(p)                            
disp("\t                             IIII                  IIII   ")
pause(p)                            
disp("\t                             IIII                  IIII   ")
pause(p)                            
disp("\t                            IoXXoI                IoXXoI  ")
printf("%s", WHT)
pause(p)                            

disp("")
disp("")
typewriter("14.1 T / 600 MHz AVAILABLE",0.05)
disp("")
% 26*0.05 = 1.3 sec
pause(2.7)

% t = 4 + 4 sec

% start ca. 1 sec after start of melody -- is good
pause(0.05)
typewriter("BOOTING SIMSPIN 4.4",0.05)
typewriter(" ...",0.25)
disp("")
% 20*0.05 = 1 sec + 1 = 2 sec
typewriter("NMR SYSTEM ONLINE!!!", 0.05)
disp("")
% 20*0.05 = 1 sec
disp("")
% t = 4 + 4 + 4 sec

% play succes music
typewriter("INSERTING SAMPLE",0.05)
typewriter(" ...\n",0.5)
typewriter("SETTING UP MACHINE", 0.05)
typewriter(" ...\n",0.5)
disp("")
pause(0.3)
typewriter("READY TO PROCEED!",0.05)
disp("")
