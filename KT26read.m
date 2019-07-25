function V =KT26read(KT26,chn)
fprintf(KT26, ['swap=smu',chn(2),'.measure.',chn(1),'()']);
fprintf(KT26, 'print(swap)');
V = str2double(fscanf(KT26));
end