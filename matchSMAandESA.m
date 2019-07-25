function data = matchSMAandESA(SMA,ESA,Vdev,tempAtn)
% ESA Must be set first to run this function
% Swpanil 2018 10 06
%%

data(length(Vdev)) = struct();
if nargin == 3
    tempAtn = input('Input Current Setting of Attenuator: ');
end
for i=length(Vdev)
    [~, ~, rmSV1, ~]=readPOWesaInstant(ESA, 'VOLT',1);
    OCV1 = str2double(query(SMA, ':sour:pow:lev?'))*1000;
    % Calculate Loss
    data(i).Loss = lossSgen2Dev(OCV1,rmSV1*1000);
    data(i).Vsig=dev2sgen(Vdev(i),Loss);
    if data(i).Vsig < 1200
        RSGrmpV(SMA,data(i).Vsig,100);
        [~, ~, rmSV2, ~]=readPOWesaInstant(ESA, 'VOLT',1);
        data(i).Vdev = rmSV2;
        data(i).VAtn = tempAtn;
    else
        disp('Resuce The loss in Variable Attecuator')
        tempAtn = input('Input Current Setting of Attenuator: ');
        data2 = matchSMAandESA(SMA,ESA,Vdev(i:end),tempAtn);
        for idata = 0:length(data2)-1
            data(i+idata).Loss = data(idata).Loss;
            data(i+idata).Vsig = data(idata).Vsig;
            data(i+idata).Vdev = data(idata).Vdev;
            data(i+idata).VAtn = data(idata).VAtn;
        end
    end
end
% while rmSV2~=Vdev
%     dFv = Vdev-rmSV2;
%     dVsig=dev2sgen(abs(dFv),Loss);
%     if dFv>0
%     RSGrmpV(SMA,Vsig+dVsig,100);
%     elseif dFv<0
%     RSGrmpV(SMA,Vsig-dVsig,100);
%     end
%     [~, ~, rmSV2, ~]=readPOWesaInstant(ESA, 'VOLT',1);
end