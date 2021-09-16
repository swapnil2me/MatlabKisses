function setKT2200_Voltage(KT2200,V,uniT)
fprintf(KT2200, ['SOUR:Volt ',num2str(V),uniT]);
end