% edlev.m
%

function edlev(numLvls_, cntFactor_, startFloor_);

    global titrationPoint plotSpectra asHppm asNppm wHv wNv wHvppm wNvppm;
    global numLvls cntFactor baseLevel asH asN cntLvls;
    global acronymProtein ligandMass proteinMass acronymLigand;
    global swH swN noiseX ns plotPoints labelShift labelSize gH gN B0 centerHppm centerNppm;
    global noiseLevel aa_string numPeaks
    
    if nargin == 0
        disp("")
        disp("Usage:")
        disp("\tedlev(number_of_levels, contour_increment, base_level_in_peak_height_fractions)");
        disp("")
        disp("\tedlev(10,1.4,0.05) ")
        disp("")
        disp("\twill draw 10 contour lines with 1.4-fold increments starting at 5% of the peak height");
        disp("")
    else
        %colorPlot = ['k';'r';'m';'b';'c';'y';'g'];
        % change yellow to dark yellow for better contrast, also added orange
        colorPlot = [[0,0,0];[1,0,0];[1,0,1];[1,0.5,0];[0.8,0.7,0];[0,1,0]; [0,1,1];[0,0,1];[0.6,0,0.8];[0.5,0.5,0.4];[0.3,0.4,0.5]];
        figure(2);
        if numLvls_ > 40
            disp("")
            disp("Ooff, that's going to take ages. Resetting to 20 levels ...")
            numLvls =20;
        else
            numLvls = numLvls_;
        end
        if nargin == 1
            cntFactor = 1.8;
            startFloor = 0.05;
        else
            if cntFactor_ < 1.05
                disp("")
                disp("Resetting contour factor to 1.05 minimum...")
                cntFactor = 1.05;
            else
                cntFactor = cntFactor_;
            end
            if nargin == 2
                startFloor = 0.05;
            else
                startFloor = startFloor_;
            end
        end
        
        % define contour levels
        % 1. take peak height as maximum across all spectra
        peakHeight = max(max(max(plotSpectra)));
        if peakHeight == 0
            disp("")
            disp("Seems you don't have any spectra yet ...")
            disp("First record a specrum and process to a 2D spectrum.")
            disp("")
        else
            baseLevel=startFloor*peakHeight;
            % 2. check against noiselevel (defined in plot2D as 3*RMS, executed as part of xfb)
            if baseLevel < noiseLevel*1
                disp("Resetting base level to be 3*noise level...")
                baseLevel = noiseLevel*1;                     % reset to minimally the noiseFloor
            end
            % 3. construct cntLvls
            posCntLvls=[baseLevel];
            for n=2:numLvls
                posCntLvls=[posCntLvls cntFactor*posCntLvls(n-1)];
            end
            negCntLvls=[-baseLevel];
            for n=2:numLvls
                negCntLvls=[cntFactor*negCntLvls(1) negCntLvls];
            end
            cntLvls = [negCntLvls posCntLvls];

            for qq=1:plotPoints
                Sr = plotSpectra(:,:,qq);
                if qq == 1
                    hold off
                end
                colorIdx = mod(qq-1,length(colorPlot))+1;
                contour(asHppm, asNppm, Sr, cntLvls, 'linecolor',colorPlot(colorIdx,:));
                xlabel('1H (ppm)')
                ylabel('15N (ppm)')
                set(gca,'XDir','reverse')
                set(gca,'YDir','reverse')
                hold on
            end
            % put labels
            for peak=1:numPeaks
                peakLabel = strcat(aa_string(peak),num2str(peak));
                labelShiftPpmN = 0.3;
                labelShiftPpmH = 0.1;
                text(wHvppm(peak)-labelShiftPpmH,wNvppm(peak)-labelShiftPpmN,peakLabel,"fontsize", labelSize);
                %wNvppm(peak), wNvppm(peak)-labelShiftPpmN
            end
            grid on;
           
            titlestr = sprintf("%s (%.1f kDa) titration with %s (%.1f kDa)", acronymProtein, proteinMass, acronymLigand, ligandMass);
            title(titlestr,"fontweight","bold");
            %title('1H-15N HSQC spectrum','fontweight','bold')
            % store level settings
            levSettings = [ numLvls, cntFactor, baseLevel];
        end % check peakHeight
    end
endfunction
