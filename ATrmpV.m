function OSVi=ATrmpV(AT,chnl,OSV,RmpN,freq,ps)
fprintf(AT, ['VOLT',num2str(chnl),':UNIT VRMS']);
if nargin == 4
    ps=0.05;
end
if OSV ==0
    OSV = 10;
end
OCV = str2double(query(AT, [':VOLT',num2str(chnl),'?']))*1000;

RmpSt =(OCV-OSV)/RmpN;
if RmpSt ==0
    disp('Already at OSV');
    OSVi = OSV;
    Vstr =  ['APPL',num2str(chnl),':SIN ',num2str(freq),'MHZ, ',num2str(OSV),' e-3 VRMS,0.0'];
    fprintf(AT, Vstr);
    return
end
for irmp = 1:RmpN
    OSVi=(OCV-irmp*RmpSt);
    Vstr =  ['APPL',num2str(chnl),':SIN ',num2str(freq),'MHZ, ',num2str(OSVi),' e-3 VRMS,0.0'];
    fprintf(AT, Vstr);
    pause(ps)
end
end