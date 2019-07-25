clc;
clear all;
c=299792458;
h=6.62606957e-34;%jules-seconds
ev_1=1.60217657e-19;%ev to jules
hev=h/ev_1;
x=input('enter 1 for ev to lamda or enter 2  for lamda to ev: ');
while x~=0
    if x==1
        e_ev=input('enter energy in ev: ');
        e_j=e_ev*1.60217657e-19
        lmd=hev*c*10^(9)/e_ev
    else
        lmd=input('enter wavelength in nano meter: ');
        e_j=h*c*10^(9)/lmd
        e_ev=hev*c*10^(9)/lmd
    end
    x=input('enter 1 for ev to lamda or enter 2  for lamda to ev: ');
end
