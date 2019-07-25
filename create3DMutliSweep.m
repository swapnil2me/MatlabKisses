function create3DMutliSweep(locn,flnm,sweep,Ptype)
%%
% Swapnil More
% 2018-Oct-08
cd(locn)
direct = 'Mat_file';
load([direct,'\',flnm,'.mat'],'data');
%% Determine Sweep
if strcmp(sweep,'vgac')
    x = [data(:).VgAC]';
end
if strcmp(sweep,'vgdc')
    y =unique([data(:).VgDC]);
    x = [data([data.VgDC]==y(1)).VgAC]';
end
if strcmp(sweep,'vsdac')
    x = [data(:).VsdAC]';
end
%%
for j = 1:length(y)
    fig=figure(j);hold on;
    title(['VgDC: ',num2str(y(j))])
    yF = data(find([data.VgDC]==y(j),1)).FreqF;
    tf = isfield(data,'AmpB');
    if tf
        yB = data(find([data.VgDC]==y(j),1)).FreqB;
    end
    xMat = repmat(x',length(yF),1);
    yFMat = repmat(yF,1,length(x));
    if tf
        yBMat = repmat(yB,1,length(x));
    end
    %fig=figure(fignum);hold on;
    
    if nargin==3
        for i=1:length(x)
            
            plot3(yFMat,xMat(:,i),data(i).AmpF,'LineWidth',0.5,'LineStyle','-','Color','r')
            if tf
                plot3(yBMat,xMat(:,i),data(i).AmpB,'LineWidth',0.5,'LineStyle','-','Color','b')
            end
        end
        %Plot_Prop_3D(fig,'','','','')
        %clear all;
    elseif  nargin==4
        if strcmp(Ptype,'amp')
            for i=1:length(x)
                tempData = data(([data.VgDC]==y(j)));
                ampF=tempData(i).AmpF;
                ampB=tempData(i).AmpB;
                plot3(yFMat,xMat(:,i),ampF,'LineWidth',0.5,'LineStyle','-','Color','r')
                if tf
                    plot3(yBMat,xMat(:,i),ampB,'LineWidth',0.5,'LineStyle','-','Color','b')
                end
            end
            %Plot_Prop_3D(fig,'','','','')
            %clear all;
        elseif strcmp(Ptype,'phs')
            for i=1:length(x)
                tempData = data(([data.VgDC]==y(j)));
                ampF=tempData(i).PhasF;
                ampB=tempData(i).PhasB;
                plot3(yFMat,xMat(:,i),ampF,'LineWidth',0.5,'LineStyle','-','Color','r')
                if tf
                    plot3(yBMat,xMat(:,i),ampB,'LineWidth',0.5,'LineStyle','-','Color','b')
                end
            end
            Plot_Prop_3D(fig,'','','','')
            %clear all;
        end
    end
end
end