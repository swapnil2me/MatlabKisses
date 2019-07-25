function KT26 = openKT26gpib()
%% Instrument Connection

% Find a GPIB object.
KT26 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 26, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(KT26)
    KT26 = gpib('NI', 0, 26);
else
    fclose(KT26);
    KT26 = KT26(1);
end

% Connect to instrument object, obj1.
fopen(KT26);

end