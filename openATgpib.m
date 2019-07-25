function AT = openATgpib(adrs)

% Find a GPIB object.
AT = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', adrs, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(AT)
    AT = gpib('NI', 0, adrs);
else
    fclose(AT);
    AT = AT(1);
end

% Connect to instrument object, obj1.
fopen(AT);

end
