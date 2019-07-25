function pltanyfold(locn)
close all;
%fldr = 'D:\Swapnil\Rearranged\001_Project_Data\001_Results_Folder\005_Chandan_M20e\Resonance\AfterHeating_2nd\352K\1w';
cd(locn);
fnms = dir(locn);
fnms = fnms([fnms.bytes] > 0);
[~,I]=sort([fnms.datenum],'ascend');

for i = 1:length(I)
    
    data = importdata(fnms(i).name);
    if isstruct(data)
        data = readtable(fnms(i).name);
        plot(data.Freq,data.Amp);hold on;
    else
        plot(data(:,1),data(:,2));hold on;
    end
    title(fnms(i).name);
    pause
end
end