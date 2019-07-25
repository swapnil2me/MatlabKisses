function [s, devID]=openDAQssn(Vendor,Rte)
if nargin == 0
    Vendor='ni';
    Rte=1000;
elseif nargin == 1
    Rte=1000;
end

NiDevices = daq.getDevices;
devID = NiDevices(1).ID;
s = daq.createSession(Vendor);
s.Rate = Rte;
end
