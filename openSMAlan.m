function obj1=openSMAlan(Ip)
    obj1 = instrfind('Type', 'visa-tcpip', 'RsrcName', ['TCPIP0::',Ip,'::inst0::INSTR'], 'Tag', '');

    % Create the VISA-TCPIP object if it does not exist
    % otherwise use the object that was found.
    if isempty(obj1)
        obj1 = visa('NI', ['TCPIP0::',Ip,'::inst0::INSTR']);
    else
        fclose(obj1);
        obj1 = obj1(1);
    end

    % Connect to instrument object, obj1.
    fopen(obj1);
end