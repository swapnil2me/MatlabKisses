function TSG=openTSGlan(Ip)
    TSG = instrfind('Type', 'visa-tcpip', 'RsrcName', ['TCPIP0::',Ip,'::inst0::INSTR'], 'Tag', '');

    % Create the VISA-TCPIP object if it does not exist
    % otherwise use the object that was found.
    if isempty(TSG)
        TSG = visa('NI', ['TCPIP0::',Ip,'::inst0::INSTR']);
    else
        fclose(TSG);
        TSG = TSG(1);
    end

    % Connect to instrument object, obj1.
    fopen(TSG);
end