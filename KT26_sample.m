function sample =KT26_sample(KT26,channel,parameter,n_sample)
fprintf(KT26, ['smu',channel,'.measure.count = ',num2str(n_sample)]);
fprintf(KT26, ['smu',channel,'.measure.',parameter,'(smu',channel,'.nvbuffer1)']);
fprintf(KT26, ['printbuffer(1, smu',channel,'.nvbuffer1.n, smu',channel,'.nvbuffer1)']);
V = fscanf(KT26);
sample = str2double(split(V,','));
end