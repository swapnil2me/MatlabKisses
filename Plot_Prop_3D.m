function out = Plot_Prop_3D(fig,Xnm,Ynm,Znm,Ttext)
%Ttext = '';
%Znm = '';
fig.Position=[833 113 1032 769];
fig.Color = 'white';
fig.Name = Ttext;
fig.CurrentAxes.View = [0 85];%[9.6000   22.6000];%[0.1000   79.2000];
fig.CurrentAxes.ZGrid = 'on';
title(Ttext,'FontSize',12.5);
%lgd = legend('show','Location','eastoutside');
%title(lgd,'VgAC (mV)');
ax = gca;

ax.ZGrid = 'on';
ax.YGrid = 'on';
ax.XGrid = 'on';
%ax.XLim = [-5 6];
%ax.XTick = [0];
%xticklabels({'0','2.5','5.0','7.5','10.0'});
ax.XLabel.String = Xnm;
%ax.XLabel.FontSize = 24;
%ax.XLabel.FontWeight = 'bold';
%ax.XGrid = 'on';

%ax.YLim = [0.15 0.3];
%ax.YTick = [];
%yticklabels({});
ax.YLabel.String = Ynm;
%ax.YLabel.FontSize = 24;
%ax.YLabel.FontWeight = 'bold';
%ax.YGrid = 'off';

%ax.ZLim = [0.15 0.3];
%ax.ZTick = [];
%zticklabels({});
ax.ZLabel.String = Znm;
%ax.ZLabel.FontSize = 24;
%ax.ZLabel.FontWeight = 'bold';
%ax.ZGrid = 'off';

box('on')
%ax.GridColor = [0 0 0];
%ax.LineWidth = 1.5;
ax.FontSize = 18;
%pause;
%saveas(fig,'Backbone Curve.fig')

end