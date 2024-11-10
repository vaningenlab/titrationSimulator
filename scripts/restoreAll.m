% restoreAll.m

plotAll
restoreCSP

figure(6)
hold off
plot(lConcv, CSP_o, 'ro;observed;')
h = legend("location", "southeast");
axis([0 1.05*max(lConcv) 0 1.1*max(CSP_o)])
% double-check units of ligand concentration is in mM -- see titrate.m
xlabel("ligand concentration (mM)")
ylabel("weighted chemical shift perturbation (ppm)")
title("binding curve","fontweight","bold")
plot(lConcv, CSP_f, 'b-;fit;')
h = legend("location", "southeast");
plot(lConcv, CSP_s*max(CSP_f)/max(CSP_s), 'g-;expected;')
