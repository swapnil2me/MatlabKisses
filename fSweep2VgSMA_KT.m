function data = fSweep2VgSMA_KT(sF,eF,dF,mx,SMA_Vg_Sweep,KT_Vg_Drive,SMA_Vsd,Lia)
%% Freq sweep
mx=mx*1e-6;
N = round(abs(eF-sF)/dF);
if sF>eF
    dF = -dF;
end
F=sF-dF;
figure(1);hold on;
data(N) = struct();
%data.Freq=zeros(N,1);
%data.Amp=zeros(N,1);
%data.Phs=zeros(N,1);
for i=0:N
    F =F+dF;
    mF = F-mx;
    wrteFrqPhs(SMA_Vg_Sweep,F,0)
    wrteFrq(KT_Vg_Drive,F);
    wrteFrqPhs(SMA_Vsd,mF)
    if i == 0
        [A,P]=readLIAsens(Lia,3000);
    end
    [A,P]=readLIAsens(Lia,500);
    data(i+1).Freq=F;
    data(i+1).Amp=A;
    data(i+1).Phs=P;
    %pause(0.1)
    yyaxis left
    plot(F,A*1e9,'ob','MarkerSize',1.5);
    yyaxis right
    plot(F,P,'sr','MarkerSize',2);
end
end