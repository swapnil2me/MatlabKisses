function data = fSweep(sF,eF,dF,mx,Rsg1,Rsg2,Lia)
%% Freq sweep
mx=mx*1e-6;
N = abs(eF-sF)/dF;
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
    wrteFrqPhs(Rsg1,F,0)
    wrteFrqPhs(Rsg2,mF,0)
    [A,P]=readLIA(Lia,300);
    data(i+1).Freq=F;
    data(i+1).Amp=A;
    data(i+1).Phs=P;
    %pause(0.1)
    yyaxis left
    plot(F,A*1e9,'sr');
    yyaxis right
    plot(F,P,'ob');
end
end