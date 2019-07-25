function multi1YPlt()

[FlNms,PathName] = uigetfile('*.txt','Select the .txt files','MultiSelect','on');
h = findobj('Type', 'figure');
lf = length(h);
if lf == 0
    fnum = 1;
else
    fnum = h(lf).Number + randi(h(lf).Number*100);
end
%-10.00V_VgDC_190.00_Mode1_79.0600_MHz_150.00_Mode2mV_-12dB_VgAC1_-6dB_VgAC2_300-600MHz200.00mV_-42dB_VsdAC_Loop_0.00_FWD

for i = 1:length(FlNms)
    FlNm = FlNms{i};
    k=strfind(FlNm,'_Mode1');
    FlNm(k-6:k-1)
    selctPlt1Y(FlNm,PathName,fnum)
    drawnow
    %pause(0.2)
   
end
 legend show
