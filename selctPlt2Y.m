function out = selctPlt2Y(FileName,PathName,fnum)


%% find open figures


if nargin == 0
    [FileName,PathName] = uigetfile('*.txt','Select the .txt files');
    h = findobj('Type', 'figure');
    lf = length(h);
    if lf == 0
        fnum = 1;
    else
        fnum = h(lf).Number + randi(h(lf).Number*100);
    end
    
end
data = importdata([PathName,FileName]);
fig=figure(fnum); hold on;
yyaxis left
plot(data(:,1),data(:,2),'-')
yyaxis right
plot(data(:,1),data(:,3),'-')
Plot_Prop(fig,'','lin','','lin','');
hold off;
end