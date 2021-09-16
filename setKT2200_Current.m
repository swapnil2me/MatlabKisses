function setKT2200_Current(KT2200,I)
uniT = 'mA';
fprintf(KT2200, ['SOUR:CURR ',num2str(I),uniT]);
end