function OSVi=DAQrmpV(s,OSV,OCV,RmpN,ps)
if nargin == 4
    ps=0.05;
end
if length(s.Channels) == length(OSV)
    RmpSt =(OCV-OSV)./RmpN;
    if RmpSt ==0
        disp('Already at OSV');
        OSVi = OSV;
        fprintf('VgDC  : %2.2f  Volts\n',OSVi);
        return
    end
    for irmp = 1:RmpN
        OSVi=OCV-irmp*RmpSt;
        
        outputSingleScan(s,OSVi);
        
        pause(ps)
    end
    fprintf('VgDC  : %2.2f  Volts\n',OSVi);
else
    disp('No of Channels and Voltage vector must have same length')
end

end
