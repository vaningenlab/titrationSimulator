% calcChi2.m

function chi2 = calcChi2(parVector)

    global pConcv lConcv molEqv CSP_o CSP_c
    
    KD_     = parVector(1);     % KD in uM
    maxCSP_ = parVector(2);     % CSP in Hz

    % fit using fast-exchange equation: first determine percentage bound
    
    E0_ = pConcv;
    L0_ = lConcv;
    n   = 1;
    
    a	= n;
    b	= -(n*E0_ + L0_ + KD_);
    c	= E0_.*L0_;
    C_	= (-b-sqrt(b.^2-4*a.*c))./(2*a);    % concentration complex
    pB  = C_./E0_;
    
    % fit using fast-exchange equation: then determine CSP

    CSP_c = pB.*maxCSP_;
    
    % calculate goodness of fit
    
    chi2 = sum((CSP_c - CSP_o).^2);

endfunction
