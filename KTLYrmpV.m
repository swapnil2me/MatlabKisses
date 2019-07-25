function OSVi= KTLYrmpV(obj1,OSV,RmpN,ps)

    if nargin == 3
        ps=0.05;
    end
    if OSV ==0
        OSV = 0;
    end
    data9 = query(obj1, ':Read?');
    inds=strfind(data9,',');
    OCV = str2double(data9(1:inds(1)-1))*1000;
    RmpSt =(OCV-OSV)/RmpN;
    if RmpSt ==0
        disp('Already at OSV');
        OSVi = OSV;
        return
    end
    for irmp = 1:RmpN
            OSVi=(OCV-irmp*RmpSt)/1000;
            Vstr =  [':SOUR:VOLT:LEV ',num2str(OSVi)];
            fprintf(obj1, Vstr);
            pause(ps)
    end
end