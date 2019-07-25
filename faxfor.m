function faxfor(fig,str)
for i =1:length(fig.CurrentAxes.XTickLabel)
fig.CurrentAxes.XTickLabel{i}=num2str(str2double(fig.CurrentAxes.XTickLabel{i}),str);
end
for j =1:length(fig.CurrentAxes.YTickLabel)
fig.CurrentAxes.YTickLabel{j}=num2str(str2double(fig.CurrentAxes.YTickLabel{j}),str);
end
end