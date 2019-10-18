function Vc = vtGaddPhs(vg1,vg2,phs)
% Phs in rads
    Vc = sqrt(vg1^2+vg2^2+2*vg1*vg2*cos(phs));
end