function AcPc=openAnPclan(Ip)
AcPc = instrfind('Type', 'visa-tcpip', 'RsrcName', ['TCPIP0::',Ip,'::inst0::INSTR'], 'Tag', '');

% Create the VISA-TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(AcPc)
    AcPc = visa('NI', ['TCPIP0::',Ip,'::inst0::INSTR']);
else
    fclose(AcPc);
    AcPc = AcPc(1);
end
set(AcPc, 'InputBufferSize', 1024);
set(AcPc, 'OutputBufferSize', 1024);
set(AcPc, 'EOSMode', 'read&write');
% Connect to instrument object, obj1.
fopen(AcPc);
end