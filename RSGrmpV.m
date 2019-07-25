function OSVi=RSGrmpV(SMA,OSV,RmpN,ps)
fprintf(SMA, 'UNIT:POW V');
    if nargin == 3
        ps=0.05;
    end
    if OSV ==0
        OSV = 1;
    end
    OCV = str2double(query(SMA, ':sour:pow:lev?'))*1000;
    RmpSt =(OCV-OSV)/RmpN;
    if RmpSt ==0
        disp('Already at OSV');
        OSVi = OSV;
        return
    end
    for irmp = 1:RmpN
            OSVi=(OCV-irmp*RmpSt)/1000;
            Vstr =  [':pow ',num2str(OSVi)];
            fprintf(SMA, Vstr);
            pause(ps)
    end
    OSVi = OSVi*1000;
end