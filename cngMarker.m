function cngMarker(fig,ms,mfc,mec)
ax=fig.CurrentAxes;
L =length(ax.Children);
for i=1:L
    ax.Children(i).MarkerSize=ms;
    if nargin == 4
        ax.Children(i).MarkerFaceColor=mfc{i};
        ax.Children(i).MarkerEdgeColor=mec{i};
    end
end