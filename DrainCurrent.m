function IsdM = DrainCurrent(dGdQ)
time=[0:0.00001:0.1].*1e-3;
eps = 3.9*8.85e-12;
w = 1e-6;
l = 5e-6;
A = l*w;
nlayer = 50;
%t = 0.3e-9*nlayer;
d0 = 150e-9;
OmegaF = 10e6;
VgAC = 0.1e-3;
VgDC = 5;
VsdAC = 5e-3;
%dGdQ = 100;
zamp=1e-9;
Cg = eps*A/d0/l;
dCgdz = eps*A/d0/l + 2*zamp*(eps*A/d0^2/l)+3*zamp^2*(eps*A/d0^3/l);
de=VgDC.*dCgdz.*zamp
Isd = VsdAC.*cos(OmegaF.*time).*(dGdQ.*(VgDC.*dCgdz.*zamp+Cg.*VgAC.*cos(OmegaF.*time)));
%plot(time,Isd)
IsdM=max(Isd);
end