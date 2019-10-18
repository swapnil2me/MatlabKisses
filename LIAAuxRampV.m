function OSVi =LIAAuxRampV(Lia,chn,OSV,RmpN,ps)
%OCV is in mV
if nargin == 4
    ps=0.05;
end
OCV = str2double(query(Lia,['AUXV?',num2str(chn)]))*1000;

RmpSt =((OCV-OSV)/RmpN);
if RmpSt ==0
    disp('Already at OSV');
    OSVi = OSV/1000;
    return
end
for irmp = 1:RmpN
    OSVi=(OCV-irmp*RmpSt)/1000;
    fprintf(Lia, ['AUXV',num2str(chn),',',num2str(OSVi)]);
    pause(ps);
end
end
