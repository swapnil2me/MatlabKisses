function [fs,fb] = genFreLst(sf,ef,bs,ss,fr)
er1 = fr(1):ss:fr(2);
er2 = fr(3):ss:fr(4);
fi1 = min(er1);
fe1 = max(er1);
fi2 = min(er2);
fe2 = max(er2);
fs = unique([sf:bs:fi1 er1 fe1:bs:fi2 er2 fe2:bs:ef]);
fb=sort(fs,'descend');
end