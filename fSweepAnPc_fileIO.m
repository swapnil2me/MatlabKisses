function fSweepAnPc_fileIO(sF,eF,dF,mx,GTsg,SDsg,Lia,tconst,fileID)
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
for i=0:N
    clc;
    
    F = F + dF;
    mF = F - mx;
    
    disp(['Frequency: ', num2str(F)])
    fprintf(GTsg,['freq ',num2str(F*1e6)]);
    fprintf(SDsg,['freq ',num2str(mF*1e6)]);
    
    if i == 0
        [A,P]=readLIAsens(Lia,tconst*2);
    else
        [A,P]=readLIAsens(Lia,tconst);
    end
    
    fprintf(fileID,'%12.8e,%12.8e,%12.8e\n',F,A,P);
end
end