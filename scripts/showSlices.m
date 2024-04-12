% showSlices.m

function showSlices(peakNumber, dimension)

    global titrationPoint peakStoreX peakStoreY asN asH wHv dwHv wNv dwNv zfH zfN swH swN plotPoints ppmaxis asHppm asNppm
    global aa_string easyMode
    

    if nargin < 2
        disp("")
        disp("Specify the peak (1-9) and the dimension (N/H) for the 1D projections.")
        disp("e.g. showSlices(3, \"N\") or showSlices(9,\"H\")")
        disp("I can also show both slices using \"b\", e.g. showSlices(3, \"b\")")
        disp("")
    elseif peakNumber < 0 || peakNumber > 9
        printf("Oops! Peak %d does not exist\n", peakNumber)
        disp("The peak-number has to in range 1-9: showSlices(3,\"N\")")
    elseif dimension != "N" && dimension != "H" && dimension != "b"
        disp("")
        disp("??? I only can project along \"N\" or \"H\" or both (\"b\"). Sorry dude.")
        disp("")
    elseif plotPoints == 0
        disp("")
        disp("Nothing to plot. Better first record a spectrum, dude.")
        disp("")
    else 
        % for each titration point
        if easyMode == 1
            figure(4)
        else
            figure(8);
        end
        hold off
        boxN = max(2,round(0.1*length(asN)));
        boxH = max(2,round(0.1*length(asH)));
        % set colors
        %colorPlot = ['k';'r';'m';'b';'c';'y';'g'];
        % change yellow to dark yellow for better contrast, also added orange
        colorPlot = [[0,0,0];[1,0,0];[1,0,1];[1,0.5,0];[0.8,0.7,0];[0,1,0]; [0,1,1];[0,0,1];[0.6,0,0.8];[0.5,0.5,0.4];[0.3,0.4,0.5]];
         % get index of starting postion
        iniPosN = wNv(peakNumber)/(2*pi);    % initial peak position in Hz
        iniIdxN = find((asN-iniPosN)>0)(1);   % first index
        % get index of final position
        finPosN = (wNv(peakNumber)+dwNv(peakNumber))/(2*pi);
        finIdxN = find((asN-finPosN)>0)(1);
        strIdxN = min(iniIdxN, finIdxN)-boxN;
        if strIdxN < 1
            strIdxN = 1;
        end
        endIdxN = max(iniIdxN, finIdxN)+boxN;
        if endIdxN > length(asN)
            endIdxN = length(asN);
        end
        % get index of starting postion
        iniPosH = wHv(peakNumber)/(2*pi);    % initial peak position in Hz
        iniIdxH = find((asH-iniPosH)>0)(1);     %first index
        % get index of final position
        finPosH = (wHv(peakNumber)+dwHv(peakNumber))/(2*pi);
        finIdxH = find((asH-finPosH)>0)(1);
        strIdxH = min(iniIdxH, finIdxH)-boxH;
        endIdxH = max(iniIdxH, finIdxH)+boxH;
        if strIdxH < 1
            strIdxH = 1;
        end
        if endIdxH > length(asH)
            endIdxH = length(asH);
        end
        for kk=1:titrationPoint
            % extract 2D FID for peak
            peakFIDX = peakStoreX(:,:,peakNumber, kk);
            peakFIDY = peakStoreY(:,:,peakNumber, kk);
            % process 2D FID of peak
            SpHX    = processFID(peakFIDX, zfH, 0, 0, 0, 0, swH); % amplitude modulated cosine FID
            SpHY    = processFID(peakFIDY, zfH, 0, 0, 0, 0, swH); % amplitude modulated sine FID
            peakSr  = processFID(SpHX + sqrt(-1)*SpHY, zfN, 0, 0, 0, 0, swN);
            % extract ROI
            subSpec = peakSr(strIdxN:endIdxN,strIdxH:endIdxH);
            % now sum
            colorIdx = mod(kk-1,length(colorPlot))+1;
            if dimension == "b"
                % first plot 1H dimension
                subplot(2,1,1)
                if kk == 1
                    hold off
                end
                peakProj = sum(subSpec, 1);
                plot(asHppm(strIdxH:endIdxH), peakProj, 'color',colorPlot(colorIdx,:))
                xlabel('1H (ppm)')
                axis([asHppm(endIdxH) asHppm(strIdxH)])
                set(gca,'XDir','reverse')
                if kk == 1
                    hold on
                end
                ylabel('intensity')
                peakLabel = strcat(aa_string(peakNumber),num2str(peakNumber));
                title(sprintf('1D projection peak %s 1H dimension', peakLabel), 'fontweight', 'bold')
                % then plot 15N dimension
                subplot(2,1,2)
                if kk == 1
                    hold off
                end
                peakProj = sum(subSpec,2);
                plot(asNppm(strIdxN:endIdxN),peakProj, 'color',colorPlot(colorIdx,:))
                xlabel('15N (ppm)')
                axis([asNppm(strIdxN) asNppm(endIdxN)])
                set(gca,'XDir','reverse')
                if kk == 1
                    hold on
                end
                ylabel('intensity')
                peakLabel = strcat(aa_string(peakNumber),num2str(peakNumber));
                title(sprintf('1D projection peak %s 15N dimension', peakLabel), 'fontweight', 'bold')
            elseif dimension == "N"
                peakProj = sum(subSpec,2);
                if ppmaxis == 1
                    plot(asNppm(strIdxN:endIdxN),peakProj, 'color',colorPlot(colorIdx,:))
                    xlabel('15N (ppm)')
                    axis([asNppm(strIdxN) asNppm(endIdxN)])
                    set(gca,'XDir','reverse')
                else
                    plot(asN(strIdxN:endIdxN),peakProj, 'color',colorPlot(colorIdx,:))
                    xlabel('15N (Hz)')
                end
                ylabel('intensity')
                peakLabel = strcat(aa_string(peakNumber),num2str(peakNumber));
                title(sprintf('1D projection peak %s', peakLabel), 'fontweight', 'bold')
            else
                peakProj = sum(subSpec, 1);
                if ppmaxis == 1
                    plot(asHppm(strIdxH:endIdxH), peakProj, 'color',colorPlot(colorIdx,:))
                    xlabel('1H (ppm)')
                    axis([asHppm(endIdxH) asHppm(strIdxH)])
                    set(gca,'XDir','reverse')
                else
                    plot(asH(strIdxH:endIdxH), peakProj, 'color',colorPlot(colorIdx,:))
                    xlabel('1H (Hz)')
                end
                ylabel('intensity')
                peakLabel = strcat(aa_string(peakNumber),num2str(peakNumber));
                title(sprintf('1D projection peak %s', peakLabel), 'fontweight', 'bold')
            end
            if kk == 1
                hold on
            end
            % store peakintensity profile?
         end
    end


endfunction

