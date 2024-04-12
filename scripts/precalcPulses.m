% precalcPulses.m

% these now include the free precession Liouvillian! 
% so it includes off resonance effects, optionally

pHx180 = expm(pHx*my_pi*p1/trup + offResonance*2*p1*1e-6*LV);
pHy180 = expm(pHy*my_pi*p1/trup + offResonance*2*p1*1e-6*LV);

pHx90m = expm(pHx*my_pi*0.5*-1*p1/trup+offResonance*p1*1e-6*LV);
pHx90p = expm(pHx*my_pi*0.5*+1*p1/trup+offResonance*p1*1e-6*LV);
pHy90m = expm(pHy*my_pi*0.5*-1*p1/trup+offResonance*p1*1e-6*LV);
pHy90p = expm(pHy*my_pi*0.5*+1*p1/trup+offResonance*p1*1e-6*LV);

pNy180 = expm(pNy*my_pi+offResonance*2*p21*1e-6*LV);
pNx180 = expm(pNx*my_pi+offResonance*2*p21*1e-6*LV);

pNx90m = expm(pNx*my_pi*0.5*-1+offResonance*p21*1e-6*LV);
pNx90p = expm(pNx*my_pi*0.5*+1+offResonance*p21*1e-6*LV);
pNy90m = expm(pNy*my_pi*0.5*-1+offResonance*p21*1e-6*LV); 
pNy90p = expm(pNy*my_pi*0.5*+1+offResonance*p21*1e-6*LV);


