function KT33=openKT33lan(Ip)
    KT33 = instrfind('Type', 'visa-tcpip', 'RsrcName', ['TCPIP0::',Ip,'::inst0::INSTR'], 'Tag', '');

    % Create the VISA-TCPIP object if it does not exist
    % otherwise use the object that was found.
    if isempty(KT33)
        KT33 = visa('NI', ['TCPIP0::',Ip,'::inst0::INSTR']);
    else
        fclose(KT33);
        KT33 = KT33(1);
    end

    % Connect to instrument object, obj1.
    fopen(KT33);
end