function obj1 = openLIA
obj1 = instrfind('Type', 'visa-gpib', 'RsrcName', 'GPIB0::8::INSTR', 'Tag', '');

% Create the VISA-GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = visa('NI', 'GPIB0::8::INSTR');
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

end