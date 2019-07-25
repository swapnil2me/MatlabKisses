function JumpData = jumpDataAuto(locn,flnm,thres)
%% Description
% Creates Jump data from the resonance sweep loaded form 'flnm' MAT file
% The frequency data must be uniform
% i.e. the flnm.Mat must have been created usung createMatUniF.m
%Saves data in separate JumpData.Mat

% Swapnil More 07/09/2018
cd(locn);
load(flnm,'data');
frqF = [data.FreqF];
frqB = [data.FreqB];
N=length(data);
fig=figure(fignum);hold on;

%% create JumpData
%JumpData(length(data))=struct()
JumpData(N).VgDC = [];
JumpData(N).VgAC = [];
JumpData(N).VsdAC = [];
JumpData(N).JUFfreq = [];
JumpData(N).JDFfreq = [];
JumpData(N).JUBfreq = [];
JumpData(N).JDBfreq = [];
JumpData(N).JUFamp = [];
JumpData(N).JDFamp = [];
JumpData(N).JUBamp = [];
JumpData(N).JDBamp = [];
%% Sweep Data
for i=1:length(data)
    if data(i).VgAC>10
    JumpData(i).VgDC = data(i).VgDC;
    JumpData(i).VgAC = data(i).VgAC;
    JumpData(i).VsdAC = data(i).VsdAC;
    ampF = data(i).AmpF;
    ampB = data(i).AmpB;
    %% selecting maximums
    MxLstF = abs(diff((ampF)));
    MxLstB = abs(diff((ampB)));
    logiF = MxLstF>max(MxLstF)/thres;
    logiB = MxLstB>max(MxLstB)/thres;
    indF = find(logiF);
    indB = find(logiB);
    JF=frqF(logiF);
    JB=frqB(logiB);
    AF = ampF(logiF);
    AB = ampB(logiB);
    %% FWD
    for j = 1:length(indF)
        if (ampF(indF(j))-ampF(indF(j)+1))>0
            JumpData(i).JDFfreq = [JumpData(i).JDFfreq JF(j)];
            JumpData(i).JDFamp = [JumpData(i).JDFamp AF(j)];
            plot(JumpData(i).VgAC,JF(j),'vr')
        elseif (ampF(indF(j))-ampF(indF(j)+1))<0
            JumpData(i).JUFfreq = [JumpData(i).JUFfreq JF(j)];
            JumpData(i).JUFamp = [JumpData(i).JUFamp AF(j)];
            plot(JumpData(i).VgAC,JF(j),'^r')
        end
    end
    
    %% BKW
    for j = 1:length(indB)
        if (ampB(indB(j))-ampB(indB(j)+1))<0
            JumpData(i).JUBfreq = [JumpData(i).JUBfreq JB(j)];
            JumpData(i).JUBamp = [JumpData(i).JUBamp AB(j)];
            plot(JumpData(i).VgAC,JB(j),'^b')
        elseif (ampB(indB(j))-ampB(indB(j)+1))>0
            JumpData(i).JDBfreq = [JumpData(i).JDBfreq JB(j)];
            JumpData(i).JDBamp = [JumpData(i).JDBamp AB(j)];
             plot(JumpData(i).VgAC,JB(j),'vb')
        end
    end
    
   
    %pause
    end
end

save('JumpData.mat','JumpData');
Plot_Prop(fig,'Vg_{ac} (mV)','lin','Freq (MHz)','lin','Jump Frequencies')