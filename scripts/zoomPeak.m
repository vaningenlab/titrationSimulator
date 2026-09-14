% zoomPeak.m
%
    
function zoomPeak(peakNumber, boxHp, boxNp)

    global wHv wNv B0 gN gH numPeaks wHvppm wNvppm centerHppm centerNppm

    if nargin == 0
        disp("")
        printf("Include a peak to zoom in on, e.g. %s.\n", dispCommand("zoomPeak(3)"))
        disp("Only specify the residue number, not the amino acid!")
        printf("You can also specify the zoom range in ppm, e.g.\n", dispCommand("zoomPeak(3,0.1,0.5)"));
        printf("Use %s to return to full view\n", dispCommand("zoomFull"))
        disp("")
    else
        figure(2);
        if nargin == 1
            boxHp = 0.15;     % box size in ppm
            boxNp = 1.5;       
        elseif nargin == 2
            boxNp = boxHp;
        end
        if peakNumber > 0 && peakNumber <= numPeaks
            % note that only axis is reversed not the actual data!
            pcpH = wHvppm(peakNumber);           % 1H  peak center frequency in ppm
            pcpN = wNvppm(peakNumber);           % 15N peak center frequency in ppm
            axis([pcpH-boxHp pcpH+boxHp pcpN-boxNp pcpN+boxNp]);
        else
            printf("Oops! Peak %d does not exist\n", peakNumber)
            printf("The peak-number has to in range 1-%d: e.g. %s\n", dispCommand("zoomPeak(3)"), numPeaks)
        end
    end

end



