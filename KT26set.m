function OSV =KT26set(KT26,chn,OSV)
V = num2str(OSV);
fprintf(KT26, ['smu',chn(2),'.source.level',chn(1),'=',V]);
end