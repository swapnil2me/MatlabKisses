function IsdM = DrainCurrent2(dGdV)
%time=[0:0.00001:0.1].*1e-3;
eps = 3.9*8.85e-12;
w = 0.2e-6;

l = 1e-6;
A = l*w;
%nlayer = 50;
%t = 0.3e-9*nlayer;
d0 = 200e-9;
OmegaG = 50e6;
mf = 2017;
OmegaS = OmegaG+mf;
tp = 2*pi/OmegaG;
t = 0:tp/100:5*tp;
VgAC = 0.1e-3;
VgDC = 5;
VsdAC = 5e-3;
%dGdQ = 100;
zamp=0.5e-9;
Cg0 = eps*A/d0/l;
Gdc = 1/18e3;
CgP = Cg0.*(1+zamp*2/d0+3*zamp^2/d0^2);
CgAC = eps*A/(d0-zamp)/l;
Zac =  zamp;
qac = CgP.*Zac.*cos(OmegaG.*t).*VgDC+CgAC.*VgAC.*cos(OmegaG.*t);
Gac = (dGdV/Cg0).*qac;
Isd = (Gdc+Gac).*VsdAC.*cos(OmegaS.*t);
%Imix = ((dGdV/Cg0).*(CgP.*Zac.*VgDC+CgAC.*VgAC)).*VsdAC.*cos(OmegaS.*t).*cos(OmegaG.*t);
plot(t,Isd)%,t,Imix);
IsdM = max(Isd);
end