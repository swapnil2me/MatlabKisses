function KT2200 = openKT2200GPIB()
%% Instrument Connection

% Find a GPIB object.
KT2200 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 22, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(KT2200)
    KT2200 = gpib('NI', 0, 22);
else
    fclose(KT2200);
    KT2200 = KT2200(1);
end

% Connect to instrument object, obj1.
fopen(KT2200);


end