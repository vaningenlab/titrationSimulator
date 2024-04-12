% zoomPeak.m
%
    
function zoomPeak(peakNumber, boxH, boxN)

    global wHv wNv B0 gN gH ppmaxis numPeaks wHvppm wNvppm centerHppm centerNppm

    if nargin == 0
        disp("")
        disp("Include a peak to zoom in on, e.g. zoomPeak(3).")
        disp("Only specify the residue number, not the amino acid!")
        if ppmaxis == 1
            disp("You can also specify the zoom range in ppm, e.g. zoomPeak(3,0.1,0.5)");
        else
            disp("You can also specify the zoom range in Hz, e.g. zoomPeak(3,50,100)");
        end
        disp("")
    else
        figure(2);
        if nargin == 1
            boxHp = 0.15;     % box size in ppm
            boxNp = 1.5;       
            boxH = 100;         % box size in Hz
            boxN = 100;
        end
        if nargin == 2
            boxN  = boxH;
            boxNp = boxHp;
        end
        if nargin == 3
            boxHp = boxH;
            boxNp = boxN;
        end
        if peakNumber > 0 && peakNumber <= numPeaks
            if ppmaxis == 1
                % note that only axis is reversed not the actual data!
                pcpH = wHvppm(peakNumber);           % 1H  peak center frequency in ppm
                pcpN = wNvppm(peakNumber);           % 15N peak center frequency in ppm
                axis([pcpH-boxHp pcpH+boxHp pcpN-boxNp pcpN+boxNp]);
            else
                pcH = wHv(peakNumber)/(2*my_pi);       % 1H  peak center frequency in Hz
                pcN = wNv(peakNumber)/(2*my_pi);       % 15N peak center frequency in Hz
                axis([pcH-boxH pcH+boxH pcN-boxN pcN+boxN]);
            end
        else
            printf("Oops! Peak %d does not exist\n", peakNumber)
            printf("The peak-number has to in range 1-%d: zoomPeak(3)\n", numPeaks)
        end
    end

end



