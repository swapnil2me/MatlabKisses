function [A,P] = readLIA(LIA,tCon)
pause(tCon/1000)
data4 =query(LIA, 'lias?3');
while str2double(data4) == 1
    clc;
    disp('LIA Unlocked')
    pause(tCon/1000)
    data4 = query(LIA, 'lias?3');
end
clc;
disp('LIA Locked')
data2 = query(LIA, 'SNAP?3,4');
ind = strfind(data2,',');
A = str2double(data2(1:ind-1));
P = str2double(data2(ind+1:end));
end