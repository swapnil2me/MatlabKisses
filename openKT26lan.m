function KT26 = openKT26lan()
%% Instrument Connection

% Find a VISA-TCPIP object.
KT26 = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP0::169.254.0.1::inst0::INSTR', 'Tag', '');

% Create the VISA-TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(KT26)
    KT26 = visa('NI', 'TCPIP0::169.254.0.1::inst0::INSTR');
else
    fclose(KT26);
    KT26 = KT26(1);
end

% Connect to instrument object, obj1.
fopen(KT26);

end