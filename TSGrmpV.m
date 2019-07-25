function OSVi=TSGrmpV(obj1,OSV,RmpN,ps)
    if nargin == 3
        ps=0.05;
    end
    if OSV ==0
        OSV = 1;
    end
    OCV = str2double(query(obj1, 'AMPR? RMS'))*1000;
    RmpSt =(OCV-OSV)/RmpN;
    if RmpSt ==0
        disp('Already at OSV');
        OSVi = OSV;
        return
    end
    for irmp = 1:RmpN
            OSVi=(OCV-irmp*RmpSt)/1000;
            Vstr =  ['AMPR ',num2str(OSVi),' RMS; NOIS 0;'];
            fprintf(obj1, Vstr);
            pause(ps)
    end
end