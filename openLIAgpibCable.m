function LIA = openLIAgpibCable(adrs)
% Find a GPIB object.
LIA = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', adrs, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(LIA)
    LIA = gpib('NI', 0, adrs);
else
    fclose(LIA);
    LIA = LIA(1);
end

% Connect to instrument object, obj1.
fopen(LIA);

end
