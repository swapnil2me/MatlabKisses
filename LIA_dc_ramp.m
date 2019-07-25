function OSVi= LIA_dc_ramp(Lia,chn,OSV,RmpN,ps)
% OSV in volts

    if nargin == 4
        ps=0.05;
    end
    if OSV == 0
        OSV = 0;
    end
    data9  = query(Lia, 'AUXV?3');
    OCV = str2double(data9);
    RmpSt =(OCV-OSV)/RmpN;
    if RmpSt == 0
        disp('Already at OSV');
        OSVi = OSV;
        return
    end
    for irmp = 1:RmpN
            OSVi=(OCV-irmp*RmpSt);
            Vstr =  ['AUXV',chn,',',num2str(OSVi)];
            fprintf(Lia, Vstr);
            pause(ps)
    end
end