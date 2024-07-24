% peakInfo.m

function peakInfo(peakNumber)

    global wHv wNv dwHv dwNv koff wHvppm wNvppm dwHvppm dwNvppm centerHppm centerNppm my_pi aa_string

    if nargin == 0
        disp("")
        disp("Specify a peak for examination, e.g. peakInfo(3).")
        disp("")
    else
        p = peakNumber;
        peakLabel = strcat(aa_string(p),num2str(p));
        disp("")
        printf("\t*** details of peak %s ***\n", peakLabel)
        disp("")
        printf("\tposition free state  (H/N, ppm)  : %6.3f / %6.2f\n", 2*centerHppm - wHvppm(p), 2*centerNppm - wNvppm(p));
        printf("\tposition bound state (H/N, ppm)  : %6.3f / %6.2f\n", 2*centerHppm - (wHvppm(p)+dwHvppm(p)), 2*centerNppm -(wNvppm(p)+dwNvppm(p)));
        printf("\tchemical shift perturbation (Hz) : %6.1f / %6.1f\n", dwHv(p)/(2*my_pi), dwNv(p)/(2*my_pi));
        printf("\tdw/kex @ midpoint (H/N)          : %6.2f / %6.2f\n", abs(dwHv(p)/(2*koff)), abs(dwNv(p)/(2*koff)));
        disp("")
    end
   
endfunction
