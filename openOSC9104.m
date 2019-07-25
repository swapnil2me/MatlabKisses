function MSO=openOSC9104(Ip)
if nargin==0
    ip='169.254.105.220';
end
    %% Instrument Connection

% Find a VISA-TCPIP object.
MSO = instrfind('Type', 'visa-tcpip', 'RsrcName', ['TCPIP0::',ip,'::inst0::INSTR'], 'Tag', '');

% Create the VISA-TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(MSO)
    MSO = visa('NI', ['TCPIP0::',ip,'::inst0::INSTR']);
else
    fclose(MSO);
    MSO = MSO(1);
end

% Connect to instrument object, obj1.
fopen(MSO);

end

