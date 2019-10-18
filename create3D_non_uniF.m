function fig=create3D_non_uniF(locn,flnm,sweep,Ptype)
%%
% Swapnil More
% 2018-Oct-08
cd(locn)
direct = 'Mat_file';
load([direct,'\',flnm,'.mat'],'data');
if strcmp(sweep,'vgac')
    x = [data(:).VgAC]';
end
if strcmp(sweep,'vgdc')
    x = [data(:).VgDC]';
end
if strcmp(sweep,'vsdac')
    x = [data(:).VsdAC]';
end


fig=figure(fignum);hold on;
if nargin==3
    for i=1:length(x)
        yF = [data(i).FreqF];
        tf = isfield(data,'AmpB');
        
        xMat = repmat(x',length(yF),1);
        yFMat = repmat(yF,1,length(x));
        
        plot3(yFMat,xMat(:,i),data(i).AmpF,'LineWidth',0.5,'LineStyle','-','Color','r')
        if tf
            yB = [data(i).FreqB];
            yBMat = repmat(yB,1,length(x));
            plot3(yBMat,xMat(:,i),data(i).AmpB,'LineWidth',0.5,'LineStyle','-','Color','b')
        end
    end
    Plot_Prop_3D(fig,'','','','')
    clear all;
elseif  nargin==4
    if strcmp(Ptype,'amp')
        
        for i=1:length(x)
            yF = [data(i).FreqF];
            tf = isfield(data,'AmpB');
            
            xMat = repmat(x',length(yF),1);
            yFMat = repmat(yF,1,length(x));
            
            plot3(yFMat,xMat(:,i),(data(i).AmpF).*1e9,'LineWidth',0.5,'LineStyle','-','Color','r')
            if tf
                yB = [data(i).FreqB];
                yBMat = repmat(yB,1,length(x));
                plot3(yBMat,xMat(:,i),(data(i).AmpB).*1e9,'LineWidth',0.5,'LineStyle','-','Color','b')
            end
            ylabel('I_d (nA)');
            xlabel('Freq (MHz)');
        end
        Plot_Prop_3D(fig,'','','','')
        clear all;
    elseif strcmp(Ptype,'phs')
        for i=1:length(x)
            yF = [data(i).FreqF];
            tf = isfield(data,'AmpB');
            
            xMat = repmat(x',length(yF),1);
            yFMat = repmat(yF,1,length(x));
            
            plot3(yFMat,xMat(:,i),unwrap([data(i).PhasF].*pi./180),'LineWidth',0.5,'LineStyle','-','Color','r')
            if tf
                yB = [data(i).FreqB];
                yBMat = repmat(yB,1,length(x));
                plot3(yBMat,xMat(:,i),flipud((flipud([data(i).PhasB].*pi./180))),'LineWidth',0.5,'LineStyle','-','Color','b')
            end
        end
        Plot_Prop_3D(fig,'','','','')
        clear all;
    end
end
end