function OSVi =KT2200rampV(KT22,OSV,RmpN,ps)
%OCV is in mV
if nargin == 3
    ps=0.05;
end
OCV = readKT2200_Voltage(KT22)*1000;

RmpSt =((OCV-OSV)/RmpN);
if RmpSt ==0
    disp('Already at OSV');
    OSVi = OSV/1000;
    return
end
for irmp = 1:RmpN
    OSVi=(OCV-irmp*RmpSt)/1000;
    setKT2200_Voltage(KT22,OSVi,'V')
    pause(ps);
end
end
