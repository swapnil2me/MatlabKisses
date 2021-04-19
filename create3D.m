function fig=create3D(locn,flnm,sweep,Ptype)
%%
% Swapnil More
% 2018-Oct-08
cd(locn)
stp = 5;
direct = 'Mat_file';
load([direct,'/',flnm,'.mat'],'data');
if strcmp(sweep,'vgac')
x = [data(:).VgAC]';
end
if strcmp(sweep,'vgdc')
x = [data(:).VgDC]'
end
if strcmp(sweep,'vsdac')
x = [data(:).VsdAC]';
end
yF = [data.FreqF];
tf = isfield(data,'AmpB');
if tf
yB = [data.FreqB];
end
xMat = repmat(x',length(yF),1);
yFMat = repmat(yF,1,length(x));
if tf
yBMat = repmat(yB,1,length(x));
end
fig=figure(fignum);hold on;
bkgAmp = 0;%data([data.VgDC]==0).AmpF;
bkgPhs = 0;%data([data.VgDC]==0).AmpF;
if nargin==3
    for i=1:stp:length(x)

        plot3(yFMat,xMat(:,i),data(i).AmpF - bkgAmp,'LineWidth',0.5,'LineStyle','-','Color','r')
        if tf
        plot3(yBMat,xMat(:,i),data(i).AmpB,'LineWidth',0.5,'LineStyle','-','Color','b')
        end
    end
    Plot_Prop_3D(fig,'','','','')
    clear all;
elseif  nargin==4
    if strcmp(Ptype,'amp')
        for i=1:stp:length(x)
            plot3(yFMat,xMat(:,i),data(i).AmpF-bkgAmp,'LineWidth',0.5,'LineStyle','-','Color','r')
            if tf
            plot3(yBMat,xMat(:,i),data(i).AmpB-bkgAmp,'LineWidth',0.5,'LineStyle','-','Color','b')
            end
        end
        Plot_Prop_3D(fig,'','','','')
        clear all;
    elseif strcmp(Ptype,'phs')
        for i=1:stp:length(x)
            plot3(yFMat,xMat(:,i),unwrap([data(i).PhasF].*pi./180),'LineWidth',0.5,'LineStyle','-','Color','r')
            if tf
            plot3(yBMat,xMat(:,i),flipud(unwrap(flipud([data(i).PhasB].*pi./180))),'LineWidth',0.5,'LineStyle','-','Color','b')

            end
        end
        Plot_Prop_3D(fig,'','','','')
        clear all;
    end
end
end
