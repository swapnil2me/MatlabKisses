function out = multi2YPlt()

[FlNms,PathName] = uigetfile('*.txt','Select the .txt files','MultiSelect','on');
h = findobj('Type', 'figure');
lf = length(h);
if lf == 0
    fnum = 1;
else
    fnum = h(lf).Number + randi(h(lf).Number*100);
end
for i = 1:length(FlNms)
    FlNm = FlNms{i};
    selctPlt2Y(FlNm,PathName,fnum)
    drawnow
    pause(0.2)
end