function [A,P] = readLIAsens(LIA,tCon)
tic
pause(tCon/1000)
ovI =str2double(query(LIA, 'lias?0'));
ovT =str2double(query(LIA, 'lias?1'));
ovOP =str2double(query(LIA, 'lias?2'));
unlok =query(LIA, 'lias?3');
while ovI==1
    disp('Input Overload');
    ovI =str2double(query(LIA, 'lias?0'));
end

while ovOP == 1
    
    ssi = str2double(query(LIA, 'SENS ?'));
    disp(['Increasing LIA sensitivity level: ',num2str(ssi)]);
    fprintf(LIA, ['SENS ',num2str(ssi+1)]);
    pause(1.5);
    ovOP =str2double(query(LIA, 'lias?2'));
end
while ovT ==1
    disp('Time Constant Overload');
    ovT =str2double(query(LIA, 'lias?1'));
end
while str2double(unlok) == 1
    %clc;
    t = toc;
    if t > 15
        disp('LIA Unlocked')
    end
    pause(tCon/1000)
    unlok = query(LIA, 'lias?3');
end
%clc;
%disp('LIA Locked')
data2 = query(LIA, 'SNAP?3,4');
ind = strfind(data2,',');
A = str2double(data2(1:ind-1));
P = str2double(data2(ind+1:end));


end