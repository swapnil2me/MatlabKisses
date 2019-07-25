function ESA=openESAlan(Ip)
if nargin==0
    ip='169.254.179.26';
end
   %% Instrument Connection

% Find a VISA-TCPIP object.
ESA = instrfind('Type', 'visa-tcpip', 'RsrcName', ['TCPIP0::',ip,'::inst0::INSTR'], 'Tag', '');

% Create the VISA-TCPIP object if it does not exist
% otherwise use the object that was found.
if isempty(ESA)
    ESA = visa('NI', ['TCPIP0::',ip,'::inst0::INSTR']);
else
    fclose(ESA);
    ESA = ESA(1);
end
    
% Connect to instrument object, obj1.
fopen(ESA);
fprintf(ESA, 'SYST:DISP:UPD OFF');
%%

%fprintf(ESA, '*RST');

end

