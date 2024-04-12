% zg.m

% start an NMR experiment
% upon completion it needs to be processed and visualized
clc
disp("")
    
if (strcmp(expPars,"HSQC") || strcmp(expPars,"hsqc"))
    if exist("npN") && exist("pConc")
        disp("***      4. Protein HSQC      ***")
        disp("")
        if ((tau < 0.002 || tau > 0.004) && beNice == 1)
            disp("Your tau value is quite off. This is not going to work properly. You'll see.")
            disp("")
        end
        disp("Starting HSQC experiment, takes ~1 min depending on")
        disp("your number of a scans and 1H/15N acquisition times....")
        disp("Note that in real life such experiment would take ~10min up to 1hr.")
        calcEquilibriumConcSingleSite       % calculate free/bound protein (pa/pb)
        cConcv(titrationPoint) = C;         % store concentration complex
        if cConcv(titrationPoint) > pConcv(titrationPoint)
            disp("")
            disp("Hmm, wait a second, something is wrong here...")
            printf("[complex] is %.3f\n",cConcv(titrationPoint))
            printf("[protein] is %.3f\n",pConcv(titrationPoint))
            disp("Go ask your instructor.")
            disp("")
            junk=input("<>","s");
            disp("")
        end
        if cConcv(titrationPoint) == 0 && titrationPoint > 1
            disp("")
            disp("Hmm, wait a second, something is wrong here...")
            printf("[complex] is %.3f\n",cConcv(titrationPoint))
            printf("[ligand] is %.3f\n",lConcv(titrationPoint))
            disp("Go ask your instructor.")
            disp("")
            junk=input("<>","s");
            disp("")
        end
        buildExchangeMatrix                 % derive exchange matrix for this point
        totalFIDX = zeros(npN,npH);
        totalFIDY = zeros(npN,npH);
        % pre-calculate signal and noise scaling factors
        % 150 uM gives S/N of 70 in spectum w/ 0.08/0.04 acq.time and 8 scans
        signalSf = (ns/8)*(proteinConc/0.15)*proteinDilution;
        noiseSf  =  0.5*sqrt(ns/8);
        % pre-calculate noise according normal distribution with mean zero
        % note that noise has to be complex number otherwise symmetrical noise!
        noiseX = 1*(randn(npN,npH)+sqrt(-1)*randn(npN,npH));
        noiseY = 1*(randn(npN,npH)+sqrt(-1)*randn(npN,npH));
        tic();
        disp("")
        disp("Wait, initializing experiment ...")
        % here I add the acqu window
        figure(1)
        clf
        hold off
        title('acquisition window - FID', 'fontweight', 'bold')
        xlabel('acquistion time (sec)')
        ylabel('intensity')
        drawnow
        for peak = 1:numPeaks
            printf("%d ",numPeaks-peak+1);   % fake count down
            buildRelaxationMatrix           % depends on S2, but not on titration point
            precalcPropagators              % depends on w, dw, but not on titration point
            precalcPulses                   % calculate pulses including off-resonance effects
            setupMagnetization              % also defines FID McX, McY
            simHSQC                         % do NMR experiment; this calculates also t1 
                                            % which is not compatible with acqu window
                                            % that would also take excessive time?
                                            % can simply run through the values
            totalFIDX = totalFIDX + McX;    % sum FID from each peak in protein
            totalFIDY = totalFIDY + McY;    
            % add FID of peak to peakStore -- still need to add noise
            peakStoreX(:,:,peak, titrationPoint) = signalSf*McX + noiseSf*noiseX;
            peakStoreY(:,:,peak, titrationPoint) = signalSf*McY + noiseSf*noiseY;
        end
        % add signal and noise
        McX = signalSf*totalFIDX + noiseSf*noiseX;
        McY = signalSf*totalFIDY + noiseSf*noiseY;
        % define amplitude for plotting, scale by ns
        FIDamp = ns/8*round(max(real(McX(1,:))))+1;
        printf("\n")
        disp("")
        disp("Starting acquisition ...")
        disp("")
        disp("The plot shows the FID for each experiment needed to make the 2D spectrum (2nd counter)")
        disp(" and summed for each scan (first counter)")
        disp("")
        disp("==> Do not change to another plot window until acquisition is finished.<==")
        disp("")
        acq_time = toc()/8;
        % here skip or adjust number of plots shown if computer is very slow
        % typically initialization time on my laptop is ca. 10 sec, so put cutoff at 32 sec/8 = 4 sec
        % for the typical 74 points
        slowPCtime = (32*npN/74)/4;
        if acq_time < slowPCtime
            for p=1:npN/2
                % fast PC
                % need to show total FID + noise for every scan and every t1 point -- every other ns, t1
                % this is sort of fake, not the same noise as in actual FID
                % show point 2, 4, 6 till npN
                scanFIDX = signalSf*totalFIDX(p*2,:) + noiseSf*(randn(1,npH)+sqrt(-1)*randn(1,npH));
                scanFIDY = signalSf*totalFIDY(p*2,:) + noiseSf*(randn(1,npH)+sqrt(-1)*randn(1,npH));
                for scan=1:ns/2
                    figure(1)
                    hold off
                    if p == 1
                        str = sprintf("Acquisition window - FID - %d / %d - %d /%d", scan*2, ns, p*2-1, npN);
                    else
                        str = sprintf("Acquisition window - FID - %d / %d - %d /%d", scan*2, ns, p*2, npN);
                    end
                    %line(tH, real(scanFIDX),'color','b')
                    plot(tH, real(scanFIDX),'color','b')
                    title(str, 'fontweight', 'bold')
                    xlabel('acquistion time (sec)')
                    ylabel('intensity')
                    axis([0 max(tH) -FIDamp FIDamp]);
                    drawnow()
                    hold on
                    %line(tH, imag(scanFIDX),'color','r')
                    plot(tH, imag(scanFIDX),'color','r')
                    title(str,'fontweight', 'bold')
                    xlabel('acquistion time (sec)')
                    ylabel('intensity')
                    axis([0 max(tH) -FIDamp FIDamp]);
                    drawnow()
                    scanFIDX = scanFIDX + signalSf*totalFIDX(p*2,:)+noiseSf*(randn(1,npH)+sqrt(-1)*randn(1,npH));
                end % loop ns
            end % loop np
        else
            disp("")
            disp("Your computer is a bit slow...")
            disp("Adjusting the acquisition window to update every fourth point and fourth scan...")
            disp("")
            junk=input("<>","s");
            disp("")
            for p=1:npN/4
                % need to show total FID + noise for every scan and every t1 point -- every other ns, t1
                % show point 4, 8, 8 till npN modulo 4
                scanFIDX = signalSf*totalFIDX(p*4,:) + noiseSf*(randn(1,npH)+sqrt(-1)*randn(1,npH));
                scanFIDY = signalSf*totalFIDY(p*4,:) + noiseSf*(randn(1,npH)+sqrt(-1)*randn(1,npH));
                for scan=1:ns/4
                    figure(1)
                    hold off
                    if p == 1
                        str = sprintf("Acquisition window - FID - %d / %d - %d /%d", scan*4, ns, p*4-1, npN);
                    else
                        str = sprintf("Acquisition window - FID - %d / %d - %d /%d", scan*4, ns, p*4, npN);
                    end
                    %line(tH, real(scanFIDX),'color','b')
                    plot(tH, real(scanFIDX),'color','b')
                    title(str, 'fontweight', 'bold')
                    xlabel('acquistion time (sec)')
                    ylabel('intensity')
                    axis([0 max(tH) -FIDamp FIDamp]);
                    drawnow()
                    hold on
                    %line(tH, imag(scanFIDX),'color','r')
                    plot(tH, imag(scanFIDX),'color','r')
                    title(str,'fontweight', 'bold')
                    xlabel('acquistion time (sec)')
                    ylabel('intensity')
                    axis([0 max(tH) -FIDamp FIDamp]);
                    drawnow()
                    scanFIDX = scanFIDX + signalSf*totalFIDX(p*4,:)+noiseSf*(randn(1,npH)+sqrt(-1)*randn(1,npH));
                end % loop scan
            end % loop np
            % add plot of last np since maybe not modulo 4
            scanFIDX = signalSf*totalFIDX(npN,:) + noiseSf*(randn(1,npH)+sqrt(-1)*randn(1,npH));
            scanFIDY = signalSf*totalFIDY(npN,:) + noiseSf*(randn(1,npH)+sqrt(-1)*randn(1,npH));
            for scan=1:ns/4
                figure(1)
                hold off
                if p == 1
                    str = sprintf("Acquisition window - FID - %d / %d - %d /%d", scan*4, ns, p*4-1, npN);
                else
                    str = sprintf("Acquisition window - FID - %d / %d - %d /%d", scan*4, ns, p*4, npN);
                end
                %line(tH, real(scanFIDX),'color','b')
                plot(tH, real(scanFIDX),'color','b')
                title(str, 'fontweight', 'bold')
                xlabel('acquistion time (sec)')
                ylabel('intensity')
                axis([0 max(tH) -FIDamp FIDamp]);
                drawnow()
                hold on
                %line(tH, imag(scanFIDX),'color','r')
                plot(tH, imag(scanFIDX),'color','r')
                title(str,'fontweight', 'bold')
                xlabel('acquistion time (sec)')
                ylabel('intensity')
                axis([0 max(tH) -FIDamp FIDamp]);
                drawnow()
                scanFIDX = scanFIDX + signalSf*totalFIDX(npN,:)+noiseSf*(randn(1,npH)+sqrt(-1)*randn(1,npH));
            end % scan last point
        end % fast slow
            %{
            % this takes too long
            for scan=1:ns
                    hold off
                    str = sprintf("Acquisition window - FID - %d / %d - %d /%d", scan, ns, p*2, npN*2);
                    %line(tH, real(scanFIDY), 'color','b')
                    plot(tH, real(scanFIDY), 'color','b')
                    title(str)
                    xlabel('acquistion time (sec)')
                    ylabel('intensity')
                    drawnow()
                    hold on
                    %line(tH, imag(scanFIDY), 'color','r')
                    plot(tH, imag(scanFIDY), 'color','r')
                    title(str)
                    xlabel('acquistion time (sec)')
                    ylabel('intensity')
                    drawnow()
                    scanFIDY = scanFIDY + totalFIDY(p,:)+noiseSf*(randn(1,npH)+sqrt(-1)*randn(1,npH));
            end
            %}
        printf("\n");
       
        disp("Acquisition finished.")
        % now show all FIDs in t1 behind each other
        disp("")
        %junk=input("<>","s");
        %disp("")
        disp("Showing all recorded FIDs")
        disp("")
        pad = zeros(1,25);
        dim1FIDX = [];
        dim1FIDY = [];
        for qq=1:npN
            dim1FIDX= [dim1FIDX real(McX(qq,:)) pad];
            dim1FIDY= [dim1FIDY real(McY(qq,:)) pad];
        end
        figure(1)
        hold off
        plot(dim1FIDX, 'color', 'b');
        hold on
        plot(dim1FIDY, 'color', 'r');
        title('all recorded FIDs to contruct 2D 15N-HSQC')
        axis('ticy')
        axis('labely')
        ylabel('intensity')
        axis([0 length(dim1FIDY)])
        drawnow()

        if ((tau < 0.002 || tau > 0.004) && beNice == 1)
            disp("")
            disp("Better set tau back to 1/(4J)= 0.00273 and re-record the spectrum.")
        end
        disp("")
        if titrationPoint == 1 && fidShown == 0 && easyMode == 0
            disp("Type \"showFID\" at the command prompt to take a look at the FID.")
        elseif titrationPoint == 1 && fidShown == 0 && easyMode == 1
            disp("")
            disp("Let's take a closer look at how the plotted FIDs are transformed to a 2D spectrum.")
            disp("")
            junk=input("<>","s");
            disp("")
            disp("Right now all FIDs are plotted after each other.")
            disp("Zoom in on the plot to see the individual FIDs.")
            if strcmp(graphics_toolkit, 'qt') == 1
                %disp("Use the magnifying glass icon to activate zoom mode")
                disp("Use the zoom (+) button to activate zoom mode and drag a rectangle to zoom in")
                disp("Click the button with a 1 inside the magnifying glass to go back to the full view.")
            elseif strcmp(graphics_toolkit, 'fltk') == 1
                disp("Click the \"P\" button on the bottom of the figure window to activate zoom mode.")
                disp("Then right click and drag a rectangle to zoom.")
                disp("Click the \"A\" button to autoscale to the full view.")
            end
            disp("")
            junk=input("<>","s");
            disp("")
            showFID
        elseif easyMode == 2 && fidShown == 0 && titrationPoint == 4
            disp("")
            disp("Time for a little intermezzo!")
            disp("")
            disp("Let's take a closer look at how the plotted FIDs are transformed to a 2D spectrum.")
            disp("")
            junk=input("<>","s");
            disp("")
            disp("Right now all FIDs are plotted after each other.")
            disp("Zoom in on the plot to see the individual FIDs.")
            disp("")
            junk=input("<>","s");
            disp("")
            showFID
        else
            disp("Type \"xfb\" at the command prompt to process the data to a spectrum.")
        end
        disp("")
    elseif exist("pConc")
        disp("")
        disp("Error! Acquisition parameters undefined. Type eda first")
        disp("")
    else
        disp("")
        disp("Whoopsie! No sample in the magnet. Type makeSample first")
        disp("")
    end
elseif strcmp(expPars, "find90")
    disp("***      3. Pulse calibration      ***")
    disp("")
    if p1 > 0 && p1 < 1000
        printf("Recording water 1D with 4xp1 (p1= %.1f microseconds), takes ~1 sec....\n", p1)
        % 1. execute 4x90 for 1H calibration
        startH2O = [ 0; 0; 1; 0];
        simFind90
        %pause (0.5);
        nu = time();
        while time() < nu + 1
            a = 1+1;
        end
        disp("")
        disp("Acquisition finished.")
        disp("")
        disp("Type \"qfp\" at the command prompt to process the data to a spectrum.")
        disp("")
    end
    if p1 == 0
        disp("No sense in recording a spectrum without pulsing! Please set p1 between 7 and 12 microseconds.")
        disp("")
    end
    if p1 < 0
        disp("Oops, there is no negative time here. Please set p1 between 7 and 12 microseconds.")
        disp("")
    end
    if p1 > 1000
        disp("Oops, p1 is way too large, that may damage the spectrometer.")
        disp("Please set p1 between 7 and 12 microseconds.")
        disp("")
    end
elseif strcmp(expPars, "popt")
    promptForReEnter = 0;
    disp("***      3. Pulse calibration      ***")
    disp("")
    if numCalib == 0
        disp("Just hit enter at the questions below to use the default values")
        disp("for the calibration setup.")
    else
        disp("Please note: Hit enter to use default values!")
    end
    disp("")
    pS = input("Enter the starting value (in microsec, default is 0): ","s");
    pI = input("Enter the increment value (in microsec, default is 2): ","s");
    pN  = input("Enter the number of experiments (default is 21): ", "s");
    disp("")
    % check input - use default values when no value is entered
    % pulse length is between 7 and 12 to 360 is up to 48 us, so may not see the 360
    if length(pS) == 0
        pS = "0";
    elseif length(regexp(pS,'[.\d]')) < length(pS)
        promptForReEnter = 1;
    end
    if length(pI) == 0
        pI = "2";
    elseif length(regexp(pI,'[.\d]')) < length(pI)
        promptForReEnter = 1;
    end
    if length(pN) == 0
        pN = "21";
    elseif length(regexp(pN,'[.\d]')) < length(pN) 
        promptForReEnter = 1;
    end
    if  promptForReEnter == 1
        disp("")
        disp("Please enter a positive number without units!")
        disp("Type \"zg\" again to re-enter your values")
        disp("")
    else
        pS = str2num(pS);
        pI = str2num(pI);
        pN = str2num(pN);
        if pS > 1000
            disp("Oops, the pulse is way too long, that may damage the spectrometer.")
            disp("Please keep the pulse length below 100 microseconds.")
            disp("Resetting the starting value to 0 microseconds.")
            pS =0;
        end
        if pN == 0
            disp("Cannot do 0 experiments, resetting to 21 ...")
            pN = 21;
        end
        if pI == 0
            disp("No point in repeating the same pulse length each time, resetting to 1 ...")
            pI = 1;
        end
        printf("Recording %d experiments with pulse length varying between %.1f and %.1f microseconds...\n", pN, pS, pS + (pN-1)*pI)
        if easyMode == 1
            disp("The data is automatically Fourier Transformed, processed to spectra, and plotted.")
        end
        disp("")
        allH2O = [];
        figure(1)
        hold off
        printf("\tp1 ")
        for ee=1:pN
            p1 = (pS + (ee-1)*pI)/4;    % devide by 4 since simFind90 does 4*90
            printf(" %3.1f ",p1*4)
            nu = time();
            while time() < nu + 1
                a = 1+1;
            end
            startH2O = [ 0; 0; 1; 0];   % define z-magnetization
            simFind90
            qfp
            plot(allH2O);                   % plot concatenated spectra
            title("1H pulse calibration - popt", 'fontweight', 'bold')
            xlabel('experiment')
            ylabel('intensity')
            axis("ticy")
            drawnow()
        end
        printf("\n")
        %pause (0.5);
        nu = time();
        while time() < nu + 1
            a = 1+1;
        end
        if numCalib == 0
            disp("")
            disp("You see here all spectra plotted straight after each other.")
            printf("The first spectrum is recorded with p1 is %.2f microseconds.\n", pS)
            printf("The second spectrum is recorded with p1 is %.2f microseconds.\n", pS+pI)
            printf("The third with %.2f microseconds, etc.\n", pS + 2*pI)
            if pS == 0
                disp("Note that there is no signal in the first spectrum, since p1 is zero")
            end
            disp("To identify the zero-crossing, find a spectrum close to it, then count ")
            disp("to find the corresponding p1 value, using the information above.")
            disp("Note that you cannot use the mouse the identify the spectrum number.")
            disp("")
            junk=input("<>","s");
        end
        numCalib = numCalib + 1;
        disp("")
        junk=input("<>","s");
        disp("")
        if questionAsked(2) == 0 && easyMode < 3   % this is no longer skipped in easyMode == 2; since it helps to understand what goes on
            question(2)
            clc
            disp("")
            disp("To continue the calibration, type \"zg\" the command prompt")
            disp("to adapt the range and number of experiments")
            disp("")
        else
            disp("")
            disp("To continue the calibration, type \"zg\" the command prompt")
            disp("to adapt the range and number of experiments")
            disp("")
            disp("Once you found the p1 value to get a zero-crossing, set p1 to")
            disp("the pulse length needed for a 90-degree rotation:")
            disp("\t - enter the value at the command prompt by typing,")
            disp("\t   for example if you find the 360 zero crossing at 32 us:")
            disp("\t   \tp1 = 8")
            disp("\t   \tor p1 = 32/4")
            disp("\t   ==> note it is p-one not p-el or p-i! <==")
            disp("")	
            disp("To proceed to the next step, make sure to have set p1 correctly")
            disp("Then load the parameters of the HSQC experiment, by typing:")
            disp("")
            disp("rpar(\"HSQC\")")
            disp("")
        end
    end
else
    disp("I don't understand which experiment you want to do.")
    disp("First load the parameters of an experiment by typing")
    disp("\"rpar\" at the command prompt and hit return.")
    disp("")
end
