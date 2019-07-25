    clear all; close all; clc;
map=colormap('parula');
VgDC=14:-0.5:6;
for j=1:length(VgDC)
DCD = ['D:\Swapnil\Rearranged\001_Project_Data\001_Results_Folder\006_Chandan_M30_p3a\M30_p3a\resonance\after heating\1w_v1\VgDC_sweep_VsAC_sweep_v1\-22dBmVsAC_-34dBm_attn_VgAC_1987Hz_1\Loop_',num2str(j-1),'_VgDC_',num2str(VgDC(j),'%2.2f'),'V'];
%DCD='D:\Swapnil\Rearranged\001_Project_Data\001_Results_Folder\001_SiX_Devices\SiX_52_B\64_VgAC_VgDC_Sweep_FWD_only\Linear_Disp_sort';
DCD = [DCD,'\'];
files = dir([DCD,'*.txt']);
[~,b]=sort([files(:).datenum],'descend');
files(:)=files(b);
Nf = length(files);

for i=1:Nf
    tempD = dlmread([DCD,files(i).name]);
    %tempD = readtable([DCD,files(i).name]);
    plot(tempD(:,1),tempD(:,2),'Color',map((mod(i,length(map))+1),:));
    %plot(tempD.Freq,tempD.Amp,'Color',map((mod(i,length(map))+1),:));
    hold on;
    drawnow;
    %pause(0.5)
end
cd(DCD);
saveas(gcf,'FIg.fig');
close all;
end