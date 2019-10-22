function createIMGsc(locn,flnm,bkg,bkgV,ap,sweep)
cd(locn)
direct = 'Mat_file';
load([direct,'/',flnm,'.mat'],'data');
%% sort data
if nargin == 5
    dc = unique([data.VgDC]');
    gAc = unique([data.VgAC]');
    sdAc = unique([data.VsdAC]');
    if length(dc)>2
        sweep='vgdc'
    elseif length(gAc)>2
        sweep='vgac';
    elseif length(sdAc)>2
        sweep='vsdac';
    end
end
%%
[mapF,num,typ] =brewermap(120,'PuRd');
[mapB,num,typ] =brewermap(120,'Blues');
%===================================
[map1,num,typ] =brewermap(120,'PuRd');
[map2,num,typ] =brewermap(120,'RdYlBu');
[map3,num,typ] =brewermap(120,'GnBu');
%map = [map1(1:end-18,:);map2;map3(end:-1:18,:)];

%===================================
[map1,num,typ] =brewermap(30,'PuRd');
[map2,num,typ] =brewermap(30,'PuBu');
%map = [map2(1:1:end,:);map1(end:-1:1,:)];

%====================================
[map1,num,typ] =brewermap(30,'PuRd');
[map2,num,typ] =brewermap(30,'PuBu');
%map = [map2(1:1:end,:);map1(end:-1:1,:)];
%mapF = map;
%===================================
[map,num,typ] =brewermap(120,'PuRd');
mapF = map;
%===================================
[map1,num,typ] =brewermap(120,'YlGnBu');
[map2,num,typ] =brewermap(120,'YlGn');
%map = [map1(end:-1:1,:);map2(1:1:end,:)];
%mapF = map;
%===================================
[map1,num,typ] =brewermap(120,'PuRd');
[map2,num,typ] =brewermap(120,'PuBu');
[map3,num,typ] =brewermap(120,'Greens');
map = [map3(60:1:end,:);map2(80:1:end-5,:);map1(end:-1:30,:)];
%mapF = map;
%===================================
if strcmp(ap,'amp')
    ampF=[data.AmpF].*1e12;
    if strcmp(bkg,'sub')
        bkgD = [data([data(:).VgAC]==bkgV).AmpF].*1e12;
    elseif strcmp(bkg,'na')
        bkgD = zeros(length(ampF),1).*1e12;
    end
elseif strcmp(ap,'phs')
    ampF=unwrap(([data.PhasF]).*pi./180);
    if strcmp(bkg,'sub')
        bkgD = unwrap([data([data(:).VgAC]==bkgV).PhasF].*pi./180);
    elseif strcmp(bkg,'na')
        bkgD = zeros(length(ampF),1);
    end
end

%ampB=[data.AmpB];
fig=figure(fignum);
if strcmp(sweep,'vgdc')
    fig;imagesc([data.VgDC],[data.FreqF],(ampF-bkgD));
    title('Freq v/s Vg_{DC}');
elseif strcmp(sweep,'vgac')
    fig;imagesc([data.VgAC]',[data.FreqF],(ampF-bkgD));
    title('Freq v/s Vg_{AC}');
elseif strcmp(sweep,'vsdac')
    fig;imagesc([data.VsdAC],[data.FreqF],(ampF-bkgD));
    title('Freq v/s Vsd_{AC}');
end
colormap(mapF(1:1:end,:));set(gca,'Ydir','normal');
c=colorbar;
if strcmp(ap,'amp')
    
    if strcmp(bkg,'sub')
        uni = '(pA - Background)';
    elseif strcmp(bkg,'na')
        uni = '(pA)';
        
    end
    c.Label.String = ['I_{sd} ',uni];
elseif strcmp(ap,'phs')
    uni = '(Rad.)';
    c.Label.String = ['Phase ',uni];

end






if strcmp(sweep,'vgdc')
    Plot_Prop(fig,'VgDC','lin','Freq (MHz)','lin','Vg_{DC} Sweep')
elseif strcmp(sweep,'vgac')
    Plot_Prop(fig,'VgAC','lin','Freq (MHz)','lin','Vg_{AC} Sweep')
elseif strcmp(sweep,'vsdac')
    Plot_Prop(fig,'VsdAC','lin','Freq (MHz)','lin','Vsd_{AC} Sweep')
end

%figure(6);imagesc([data.VgAC],data(1).FreqB,ampB);
% title('Backward Sweep');
% colormap(mapB(20:1:end,:));set(gca,'Ydir','normal');
clear all;
end