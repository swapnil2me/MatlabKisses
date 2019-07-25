function DAQchanel(s,devID,Chn,mode)

if length(Chn)~=length(mode)
    disp('verified')
    return
end
for i=1:length(Chn)
    if mode(i)=='I'
        md = 'Current';
    elseif mode(i)=='V'
        md = 'Voltage';
    end
addAnalogOutputChannel(s,devID,Chn(i),md)
end