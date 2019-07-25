function AnPc = openAnaPicoLan()
%% Instrument Connection

% Find a VISA-TCPIP object.
AnPc = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP0::169.254.7.42::inst0::INSTR', 'Tag', '');

% Create the VISA-TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(AnPc)
    AnPc = visa('NI', 'TCPIP0::169.254.7.42::inst0::INSTR');
else
    fclose(AnPc);
    AnPc = AnPc(1);
end

% Connect to instrument object, obj1.
fopen(AnPc);

end
