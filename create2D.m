function create2D(locn,flnm)
cd(locn)
direct = 'Mat_file';
load([direct,'\',flnm,'.mat'],'data');
x = [data(:).VgAC]';
map = jet(length(x));
fig = figure(fignum);hold on;
for i=1:length(x)
    yf = [data(end).FreqF];
    yb = [data(end).FreqB];
    ampF = [data(i).AmpF];
    ampB = [data(i).AmpB];
    plot(yf,medfilt1(ampF,1),'Color',map(i,:));
    %plot(yb,ampB,'LineWidth',0.5,'LineStyle','--','Color','b');
    %pause
end
%Plot_Prop_3D(fig,'','','','')
clear all;
end