% showFI2D.m
% for easyMode=2

if easyMode == 1
    figure(2)
else 
    figure(4)
end

SpHX    = processFID(McX, zfH, 0, 0, 0, 0, swH); # amplitude modulated cosine FID
SpHY    = processFID(McY, zfH, 0, 0, 0, 0, swH); # amplitude modulated sine FID
Sr      = processFID(SpHX + sqrt(-1)*SpHY, zfN, 0, 0, 0, 0, swN);

% calculate axis

saxisH		= 1;
for q=2:zfH
	saxisH=[saxisH q];
end
saxisN		= 1;
for q=2:zfN
	saxisN=[saxisN q];
end

asH 	  = (saxisH - zfH/2 -1)./(zfH/2).*swH/2;			% as in relative Hz
                                                        % removed -0.5 to have extact match with input Hz
                                                        % change to -1
asHppm	  = fliplr(asH*2*my_pi/(gH*B0*1e-6) + centerHppm);

asN       = (saxisN - zfN/2 -1)./(zfN/2).*swN/2;            % as in relative Hz
                                                        % removed -0.5 to have extact match with input Hz
                                                        % changed to -1
asNppm    = fliplr(asN*2*my_pi/(gN*B0*1e-6) + centerNppm);  

disp("")
disp("Now let's zoom in on the very first FID.")
disp("This shows you the free induction decay in the 1H dimension.")
disp("Just as the FID of a 1D 1H spectrum.")

hold off
% this works
plot(tH, real(McX(1,:)))
xlabel('acquisition time 1H')
ylabel('signal intensity')
title('FID #1 of 2D HSQC along 1H dimension (real part)','fontweight', 'bold')

disp("")
disp("If you do a FT of this FID you get a 1H spectrum.")
disp("")
junk=input("<>","s");
disp("")

hold off
% this works
plot(asHppm, SpHX(:,1))
xlabel('1H (ppm)')
ylabel('signal intensity')
title('Spectrum #1 of 2D HSQC along 1H dimension (real part)','fontweight', 'bold')
set(gca,'XDir','reverse')

disp("")
disp("A similar thing is true for say the 11th FID that was recorded.")
disp("")
junk=input("<>","s");
disp("")
disp("Here you see the FID")

hold off
% this works
plot(tH, real(McX(11,:)))
xlabel('acquisition time 1H')
ylabel('signal intensity')
title('FID #11 of 2D HSQC along 1H dimension (real part)','fontweight', 'bold')
set(gca,'XDir','normal')

disp("")
disp("And again if you do a FT of this FID you get a 1H spectrum.")
disp("")
junk=input("<>","s");
disp("")

hold off
% this works
plot(asHppm, SpHX(:,11))
xlabel('1H (ppm)')
ylabel('signal intensity')
title('Spectrum #11 of 2D HSQC along 1H dimension (real part)','fontweight', 'bold')
set(gca,'XDir','reverse')

disp("You can see that the intensities of the peaks are now different.")
disp("Some peaks are negative and some are positive.")
disp("This is because the 1H peak intensity is encoded with the 15N frequency!")
disp("")
junk=input("<>","s");
disp("")

disp("Let's zoom out again to the full series of FIDs recorded. ")
disp("")
junk=input("<>","s");
disp("")

hold off
plot(dim1FIDX, 'color', 'b');
hold on
plot(dim1FIDY, 'color', 'r');
title('all recorded FIDs to contruct 2D 15N-HSQC')
axis('ticy')
axis('labely')
ylabel('intensity')
axis([0 length(dim1FIDY)])
set(gca,'XDir','normal')

disp("The first step to get the 2D spectrum is to sort all FIDs as a 2D maxtrix")

disp("")
junk=input("<>","s");
disp("")

hold off
mesh(tH, tN, real(McX))
xlabel "1H (sec)"
ylabel "15N (sec)"
zlabel "signal intensity"
title("2D FID of HSQC (real part)", 'fontweight', 'bold')

disp("This way the two time dimension become apparent: horizontal for the 1H dimension")
disp("and vertical for the 15N dimension.")
disp("This is the whole 2D FID (real part) as a mesh...")
if strcmp(graphics_toolkit,"fltk") == 1
    % on windows starting -cli forces ftlk toolkit
    disp("Click the rotate icon (R) and drag the FID around.")
else
    % assuming Qt toolkit (default Mac and windows -gui version)
    disp("Click the rotate icon and drag the FID around.")
end
disp("Do you see the decay in the FID for both dimensions?")

disp("")
junk=input("<>","s");
disp("")

disp("The next step is to Fourier Transform all rows of the 2D FID, so an FT in the 1H dimension.")
disp("")
junk=input("<>","s");
disp("")

% this works

disp("Drag around again to check that in the 1H dimension you now have peaks as in a normal spectrum,")
disp("but still a FID in the 15N dimension (real part again).")
disp("Can you see that there are different 15N frequencies present?")
mesh(tN, asHppm, SpHX)
ylabel "1H (ppm)"
xlabel "15N (sec)"
zlabel "signal intensity"
title("FID after 1H FT (real part)",'fontweight', 'bold')

disp("")
junk=input("<>","s");
disp("")
disp("The last step is then to apply Fourier Transform to all columns of the 2D matrix,")
disp("so an FT in the 15N dimension.")
disp("")
junk=input("<>","s");
disp("")


disp("Now you get the full 2D spectrum.")

contour(asHppm, asNppm, Sr, cntLvls, 'linecolor','k');
xlabel('1H (ppm)')
ylabel('15N (ppm)')
set(gca,'XDir','reverse')
set(gca,'YDir','reverse')


disp("")
disp("Now continue by typing \"xfb\"")
disp("")
fidShown = 1;