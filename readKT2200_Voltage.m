function V = readKT2200_Voltage(KT2200)
data1 = query(KT2200, 'SOUR:VOLT:LEV?');
V = str2double(data1);
end