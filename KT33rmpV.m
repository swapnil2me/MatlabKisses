function OSVi=KT33rmpV(KT33,OSV,RmpN,ps)
fprintf(KT33, 'VOLT:UNIT VRMS');
    if nargin == 3
        ps=0.05;
    end
    if OSV ==0
        OSV = 3.5;
    end
    OCV = str2double(query(KT33, 'VOLT?'))*1000;
    RmpSt =(OCV-OSV)/RmpN;
    if RmpSt ==0
        disp('Already at OSV');
        OSVi = OSV;
        return
    end
    for irmp = 1:RmpN
            OSVi=(OCV-irmp*RmpSt)/1000;
            Vstr =  ['VOLT ',num2str(OSVi)];
            fprintf(KT33, Vstr);
            pause(ps);
    end
end