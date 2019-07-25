function [Vc,Powc] = powrAfterCombnr(Vg1,Vg2,spliter_loss,comb_loss,AttnG,phs)

    v1 = poW2vtG(vtG2poW(Vg1/1000)-spliter_loss-comb_loss-AttnG);
    v2 = poW2vtG(vtG2poW(Vg2/1000)-comb_loss-AttnG);
    Vc = 1000*sqrt(v1^2+v2^2+2*v1*v2*cos(phs));
    Powc = vtG2poW(Vc/1000);
end