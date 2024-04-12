% plotBindingCurve.m

figure(6)
hold off
plot(lConcv, CSP_o, 'ro;observed;')
h = legend("location", "southeast");
axis([0 1.05*max(lConcv) 0 1.1*max(CSP_o)])
% double-check units of ligand concentration is in mM -- see titrate.m
xlabel("ligand concentration (mM)")
if ppmaxis == 1
    ylabel("weighted chemical shift perturbation (ppm)")
else
    ylabel("peak displacement (Hz)")
end
title("binding curve","fontweight","bold")
hold on
if ppmaxis == 1
    CSP_p = cConcv./pConcv.*( sqrt( (dwHvppm(peakNumberKD))^2 + (dwNvppm(peakNumberKD)/(5))^2 ) );
else
    CSP_p = cConcv./pConcv.*( sqrt( (dwHv(peakNumberKD)/(2*my_pi))^2 + (dwNv(peakNumberKD)/(2*my_pi))^2 ) );
end
plot(lConcv, CSP_p, 'g-;actual;')