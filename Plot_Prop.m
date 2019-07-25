function out = Plot_Prop(fig,Xnm,sX,Ynm,sY,Ttext,pos)
if nargin == 6
    pos = [75 84 889 889];%[75 123 577 549];
end
fig.Position=pos;
fig.Color = 'white';
%fig.Name = Ttext{1};
%title(Ttext,'FontSize',22);
%lgd = legend('show','Location','eastoutside');
%title(lgd,'VgAC (mV)');
ax = gca;
set(ax, 'XScale', sX)

%ax.XLim = [-15 15];
%ax.XTick = [0];
%xticklabels({'0','2.5','5.0','7.5','10.0'});
ax.XLabel.String = Xnm;
%ax.XLabel.FontSize = 24;
%ax.XLabel.FontWeight = 'bold';
%ax.XGrid = 'on';

%ax.YLim = [-15 15];
%ax.YTick = [];
%yticklabels({});
set(ax, 'YScale', sY)
ax.YLabel.String = Ynm;
%ax.YLabel.FontSize = 24;
%ax.YLabel.FontWeight = 'bold';
%ax.YGrid = 'off';

box('on')
%ax.GridColor = [0 0 0];
%ax.LineWidth = 1.5;
ax.FontSize = 14;
%pause;
%saveas(fig,'Backbone Curve.fig')

end