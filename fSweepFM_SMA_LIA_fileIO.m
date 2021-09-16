function fSweepFM_SMA_LIA_fileIO(sF,eF,dF,mx, Sma,Lia,tconst,fileID)
%%
% 2021-04-18 created to write data to file
% Copied from fSweepAnPc

%% Freq sweep
N = round(abs(eF-sF)/dF);
mx = mx*1e-6;
if sF>eF
    dF = -dF;
end
F=sF-dF;
fig = figure(1);
for i=0:N
    clc;
    
    F = F + dF;
    mF = F - mx;
    
    disp(['Frequency: ', num2str(F)])
    fprintf(Sma,['freq ',num2str(F*1e6)]);
    
    if i == 0
        [A,P]=readLIAsens(Lia,tconst*5);
    else
        [A,P]=readLIAsens(Lia,tconst);
    end
    
    fprintf(fileID,'%12.8e,%12.8e,%12.8e\n',F,A,P);
    yyaxis left;
    plot(F,A,'.b'); hold on
    yyaxis right;
    plot(F,P,'.r'); hold on
end
close all;
end