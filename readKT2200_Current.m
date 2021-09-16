function I = readKT2200_Current(KT2200)
data1 = query(KT2200, 'MEAS:CURR:DC?');
I = str2double(data1);
end