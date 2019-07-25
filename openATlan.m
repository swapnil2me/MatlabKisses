function AT = openATlan()

%% Instrument Connection

% Find a VISA-TCPIP object.
AT = instrfind('Type', 'visa-tcpip', 'RsrcName', 'TCPIP0::169.254.207.72::inst0::INSTR', 'Tag', '');

% Create the VISA-TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(AT)
    AT = visa('NI', 'TCPIP0::169.254.207.72::inst0::INSTR');
else
    fclose(AT);
    AT = AT(1);
end

% Connect to instrument object, obj1.
fopen(AT);

end