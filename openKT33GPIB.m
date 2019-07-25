function KT33=openKT33GPIB(PA)
if nargin == 0
    PA=17;
end
%% Instrument Connection

% Find a GPIB object.
KT33 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', PA, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(KT33)
    KT33 = gpib('NI', 0, PA);
else
    fclose(KT33);
    KT33 = KT33(1);
end

% Connect to instrument object, obj1.
fopen(KT33);
end