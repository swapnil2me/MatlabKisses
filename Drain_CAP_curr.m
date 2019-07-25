function IsdCAP = Drain_CAP_curr()
eps = 3.9*8.85e-12;
width = 0.2e-6;
length = 1e-6;
A = length*width;
d0=200e-9;
Z0=0.5e-6;
Cg=eps*A./(d0-Z0);
VgAC = 0.1e-3;
VgDC = 5;
%VsdAC = 5e-3;
OmegaG = 50e6;
mf = 2017;
%OmegaS = OmegaG+mf;
tp = 2*pi/OmegaG;
t = 0:tp/500:5*tp;
IsdCAP = Cg.*VgAC.*cos(OmegaG.*t)+(VgAC.*cos(OmegaG.*t)+VgDC).*(Z0.*OmegaG.*sin(OmegaG.*t)./(d0-Z0*cos(OmegaG.*t)).^2);
plot(t,IsdCAP)
end