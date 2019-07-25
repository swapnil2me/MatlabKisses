function OSVi =KT26rampV(KT26,chn,OSV,RmpN,ps)
%OCV is in mV
if nargin == 4
    ps=0.05;
end
OCV = KT26read(KT26,chn)*1000;

RmpSt =((OCV-OSV)/RmpN);
if RmpSt ==0
    disp('Already at OSV');
    OSVi = OSV/1000;
    return
end
for irmp = 1:RmpN
    OSVi=(OCV-irmp*RmpSt)/1000;
    fprintf(KT26, ['smu',chn(2),'.source.level',chn(1),'=',num2str(OSVi)]);
    pause(ps);
end
end
