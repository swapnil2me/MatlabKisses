function SMA = openSMAgpib(address)
%% Instrument Connection

% Find a GPIB object.
SMA = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', address, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(SMA)
    SMA = gpib('NI', 0, address);
else
    fclose(SMA);
    SMA = SMA(1);
end

% Connect to instrument object, obj1.
fopen(SMA);

end

