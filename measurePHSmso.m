function phs = measurePHSmso(MSO,chn1,chn2)
fprintf(MSO, ':ANALyze:AEDGes 1');
phs = str2double(query(MSO, [':MEAS:PHAS? ',chn1,',',chn2,',RIS']));
end
